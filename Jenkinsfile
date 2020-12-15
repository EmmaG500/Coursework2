def app
def remote = [:]
remote.name = 'emmag'
remote.host = '172.31.59.172'
remote.user = 'root'
remote.password = 'test'
remote.allowAnyHosts = true

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
			    sh "kubectl set image deployment/devopscw2 devopscw2=emmag/server_app:latest"
		    }
	    }
    }
}
