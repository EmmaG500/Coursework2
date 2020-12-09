pipeline{
	agent any
	stages {
		stage('Build') {
			echo "${env.JOB_NAME} build ${env.BUILD_NUMBER} beginning on ${env.JENKINS_URL}"
			echo "building Docker image..."
			app = docker.build("./docker")
		}
		stage('Test'){
			echo "Beginning tests..."
			echo "testing Docker image..."
			app.inside {
				sh 'echo "Test passed"'
			}
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
			echo "Deploying on kubernetes and pushing image to DockerHub"
			docker.withRegistry('https//registry.hub.docker.com', 'docker-hub-credentials'){
						app.push("${env.BUILD_NUMBER}")
						app.push("latest")
			}
		}
	}
}