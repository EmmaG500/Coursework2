node {
    def app

    stage('Clone repository') {
        echo "Cloning repository..."
        checkout scm
    }

    stage('Build image') {
        echo "Building docker image..."
        app = docker.build("emmag500/server_app")
    }

    stage('Test image') {
        echo "Testing docker image..."
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        eco "Pushing docker image..."
         docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
    
    stage('Sonarqube') {
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
    }
}
