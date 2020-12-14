node {
    def app 
    
    stage 'Clone repo') {
        checkout scm
    }
    stage('Build image') {
        app = docker.build("rhamill22/node_web_apP")
    }
    stage('Test image') {
        app.inside{
            sh 'echo "Tests passed"'
        }
    }
    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("S{env.BUILD_NUMBER}") app.push("latest")
        }
    }
    stage('Sonarqube') {
        environment {
            scannerHome = tool 'SonarQubeScanner'
        }

        withSonarQubeEnv('sonarqube') {
            sh "S{scannerHome}/bin/sonar-scanner"
        }
        timeout(time: 10, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
        }
    }
} 
