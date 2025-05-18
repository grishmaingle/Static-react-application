pipeline {
  agent any

  environment {
    DOCKER_IMAGE = 'grishmai28/react-static-app'
    DOCKER_TAG = 'latest'
  }

  stages {
          stage('Checkout') {
  steps {
    checkout scm
  }
}

    
    stage('Install Dependencies & Build') {
      steps {
        sh '''
          npm install
          npm run build
        '''
      }
    }

    stage('SonarQube Scan') {
      environment {
        SONAR_SCANNER_HOME = tool 'SonarQubeScanner'
      }
      steps {
        withSonarQubeEnv('MySonarQube') {
          sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner"
        }
      }
    }

    stage('Docker Build') {
      steps {
        sh '''
          docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
        '''
      }
    }

    stage('Trivy Scan') {
      steps {
        sh '''
          trivy image --exit-code 0 --severity MEDIUM,HIGH $DOCKER_IMAGE:$DOCKER_TAG
        '''
      }
    }

    stage('Docker Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $DOCKER_IMAGE:$DOCKER_TAG
          '''
        }
      }
    }

    stage('Deploy Container') {
      steps {
        sh '''
          docker stop react-app || true
          docker rm react-app || true
          docker run -d -p 80:80 --name react-app $DOCKER_IMAGE:$DOCKER_TAG
        '''
      }
    }
  }
}
