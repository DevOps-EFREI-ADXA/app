def appImage = ''

pipeline {
    agent {
        label 'slave'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'mvn versions:set -DnewVersion=0.0.${BUILD_NUMBER}'
                    sh 'mvn clean install -Drevision=${BUILD_NUMBER}'
                    appImage= docker.build("app:1.0.0", "--build-arg VARIABLE=0.0.${BUILD_NUMBER} .")
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