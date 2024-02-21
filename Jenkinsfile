def appImage = ''
def versionNumber = ''

pipeline {
    agent {
        label 'slave'
    }
    stages {

        stage('Git clone') {
            steps {
                git branch: 'main', credentialsId: 'github_key', url: 'git@github.com:DevOps-EFREI-ADXA/app.git'
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
                    sh "ls -a"
                    sh "chmod +x scripts/deploy-infrastructure.sh"
                    sh "./deploy-infrastructure.sh development ${versionNumber}"
                }
            }
        }
    }
}