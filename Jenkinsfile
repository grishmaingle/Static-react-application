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
        withCredentials([string(credentialsId: 'sonar_token', variable: 'SONAR_AUTH_TOKEN')]) {
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

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                            docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                            docker push ${DOCKER_IMAGE}:latest
                        """
                    }
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
