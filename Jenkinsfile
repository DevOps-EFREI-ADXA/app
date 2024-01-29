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
        stage('Deploy K8s') {
            steps {
                script {
                    sh "kubectl set image deployment/app app=danny07/app:${versionNumber}"
                }
            }
        }
    }
}