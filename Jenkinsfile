pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/grishmaingle/Static-react-application.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

       stage('SonarQube Scan') {
    steps {
        withSonarQubeEnv("${SONARQUBE_SERVER}") {
            script {
                def scannerHome = tool 'SonarQubeScanner'  // this must match the name in Global Tool Config
                sh "${scannerHome}/bin/sonar-scanner"
            }
        }
    }
}

        stage('Docker Build') {
            steps {
                sh 'docker build -t react-app .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image react-app'
            }
        }
    }
}
      
