def appImage = ''

pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'mvn clean install'  
                    appImage=docker.build("app:1.0.0")
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
        // stage('Heatlh Check') {
        //     steps {
        //         echo 'Testing..'
        //     }
        // }
    }
}