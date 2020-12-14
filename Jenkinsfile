pipeline{
	agent any
	stages {
		stage('Clone repo') {
			checkout scm
		}
		stage('Build') {
			steps {
				echo "${env.JOB_NAME} build ${env.BUILD_NUMBER} beginning on ${env.JENKINS_URL}"
				echo "building Docker image..."
				app = docker.build("emmag500/server_app")
			}
		}
		stage ('Push Image') {
			steps {
				echo 'Pushing Image...'
        			docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            				app.push("${env.BUILD_NUMBER}")
            				app.push("latest")
			}
		}
		stage('Test'){
			echo "Beginning SonarQube tests..."
			environment {
     			    scannerHome = tool 'SonarQubeScanner'
    			}
    			steps {
        		    withSonarQubeEnv('sonarqube') {
            			sh "${scannerHome}/bin/sonar-scanner"
        		}
        		timeout(time: 10, unit: 'MINUTES') {
            		    waitForQualityGate abortPipeline: true
        		}
    		}
		stage('Deploy'){
			  echo 'Deploying application to kubernetes...'			
			}
		}
	}
}
}
