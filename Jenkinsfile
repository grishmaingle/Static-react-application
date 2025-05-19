pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'MySonarQubeServer'  // Ensure this matches your Jenkins SonarQube server name
        DOCKER_IMAGE = 'grishmaingle/static-react-app'
    }

    tools {
        nodejs 'NodeJS'  // Make sure this matches the configured NodeJS tool name in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'git-creds', url: 'https://github.com/grishmaingle/Static-react-application.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

         stage('SonarQube Analysis') {
    steps {
withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
            withSonarQubeEnv("${SONARQUBE_SERVER}") {
                sh 'npx sonar-scanner ' +
                   '-Dsonar.projectKey=static-react-app ' +
                   '-Dsonar.sources=. ' +
                   '-Dsonar.host.url=http://15.206.23.10:9000 ' +
                   '-Dsonar.login=$SONAR_AUTH_TOKEN'
            }
        }
    }
}


        stage('Build Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

stage('Push to Docker Hub') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            script {
                sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                sh "docker push your-dockerhub-username/your-image-name:latest"
            }
        }
    }
}


    post {
        always {
            cleanWs()
        }
    }
}
