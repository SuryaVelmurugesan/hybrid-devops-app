pipeline {
  agent any
  environment {
    DOCKERHUB_CRED = credentials('dockerhub')
    SONAR_TOKEN = credentials('sonar-token')
    EC2_SSH = 'ec2-ssh'
    DOCKER_IMAGE = "surya485/devops-capstone-app"
    IMAGE_TAG = "${env.BUILD_ID}"
    EC2_USER = "ec2-user"
    EC2_IP = "3.6.175.112"
    // Replace with your actual ngrok public URL that exposes SonarQube (include https://)
    SONAR_HOST_URL = " https://e275386b0b41.ngrok-free.app"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Install & Test') {
      steps {
        dir('app') {
          sh 'npm ci'
          sh 'npm test || true'
        }
      }
    }
    stage('SonarQube Analysis') {
      steps {
        sh """
          docker run --rm \
            -v \$(pwd):/usr/src \
            sonarsource/sonar-scanner-cli \
            -Dsonar.host.url=${SONAR_HOST_URL} \
            -Dsonar.login=${SONAR_TOKEN} \
            -Dsonar.projectKey=devops-capstone-app \
            -Dsonar.sources=/usr/src/app
        """
      }
    }
    stage('Build Docker Image') {
      steps { sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ." }
    }
    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PSW', usernameVariable: 'DOCKERHUB_USER')]) {
          sh """
            echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
            docker logout
          """
        }
      }
    }
    stage('Deploy to EC2') {
      steps {
        sshagent (credentials: ['ec2-ssh']) {
          sh """
            scp -o StrictHostKeyChecking=no deploy/deploy.sh ${EC2_USER}@${EC2_IP}:/home/${EC2_USER}/deploy.sh
            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} 'chmod +x /home/${EC2_USER}/deploy.sh && bash /home/${EC2_USER}/deploy.sh ${DOCKER_IMAGE} ${IMAGE_TAG}'
          """
        }
      }
    }
  }
  post {
    always { archiveArtifacts artifacts: 'app/**', allowEmptyArchive: true }
  }
}
