def app

pipeline {
    agent any
    stages {
	stage('Clone Repo'){
		steps {
 			checkout scm
		}
	}
        stage('build docker image and push to dockerhub') {
            steps {
                script {
                    app = docker.build("emmag500/server_app")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                   }
                }
            }
        }
	stage('Testing with SonarQube') {
            environment {
                scannerHome = tool 'SonarQubeScanner'
            }
            steps {   
                withSonarQubeEnv('sonarqube') {
                    sh "${scannerHome}/bin/sonar-scanner -X"
                }
            }
        }
    }
}
