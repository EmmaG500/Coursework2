def app

pipeline {
    agent any
    stages {
	stage ('Build Image') {
		steps {
			script {
			 app = docker.build("emmag500/server_app:${env.BUILD_NUMBER}")
		 	}
		}
	}
        stage('push to dockerhub') {
            steps {
                script {
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
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
	    stage('Deploying to Kubernetes'){
		    steps{
			    echo "deploying..."
			    script {
				    sh "ssh ubuntu@54.208.108.210 \
				    	kubectl set image deployments/devopscw2 server-app-l824t=emmag500/server_app:${env.BUILD_NUMBER}"
			    }
		    }
	    }
    }
}
