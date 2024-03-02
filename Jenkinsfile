def appImage = ''
def versionNumber = ''
def env = 'development'
def branchName = 'main'

pipeline {
    agent {
        label 'slave'
    }
    
    stages {
        
        stage('Defining env var') {
            steps {
                script {
                    if (branchName.equalsIgnoreCase('main')) {
                        env = 'production'
                    }
                }
            }
        }
        stage('Git clone') {
            steps {
                git branch: "${branchName}", credentialsId: 'github_key', url: 'git@github.com:DevOps-EFREI-ADXA/app.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    versionNumber = "1.0.${BUILD_NUMBER}"
                    echo "Building the app with version ${versionNumber}"
                    sh "mvn versions:set -DnewVersion=${versionNumber}"
                    appImage= docker.build("danny07/app:${versionNumber}", "--build-arg VARIABLE=${versionNumber} .")
                }
            }
        }
        stage('Deploy to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_auth') {
                        appImage.push()
                    }
                }
            }
        }
        stage ('Setup Helm charts') {
            steps {
                script {
                    sh "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts"
                    sh "helm repo add grafana https://grafana.github.io/helm-charts"
                }
            }
        }
        stage('Deploy K8s') {
            steps {
                script {
                    sh "cd scripts/ chmod +x deploy-infrastructure.sh ${env} ${versionNumber} && cd .."
                }
            }
        }
        stage('Test deployment') {
            steps {
                script {
                    sh "cd scripts/ chmod +x test-deploy.sh && cd .."
                    sh "minikube kubectl -- port-forward deployment/st2dce-application 8080 --namespace ${env} &"
                    sh 'curl http://localhost:8080'
                }
            }
        }
    }
}