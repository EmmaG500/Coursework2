def app

pipeline {
    agent any
    stages {
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
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
	    stage('Deploying to Kubernetes'){
		    steps{
			    echo "deploying..."
			    script {
				    sh "ssh ubuntu@54.208.108.210"
				    sh "kubectl set image deployments/devopscw2 devopscw2=emmag500/server_app:${env.BUILD_NUMBER}"
			    }
		    }
	    }
    }
}
