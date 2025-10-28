pipeline {
  agent any
  environment {
    DOCKERHUB_CRED = credentials('dockerhub')   // username/password
    SONAR_TOKEN = credentials('sonar-token')    // secret text
    EC2_SSH = 'ec2-ssh'                         // SSH credential id
    DOCKER_IMAGE = "surya485/devops-capstone-app"
    IMAGE_TAG = "${env.BUILD_ID}"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
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
        // Use sonarsource/sonar-scanner-cli for scanning and pass token as env
        sh """
          docker run --rm \
            -e SONAR_HOST_URL=http://localhost:9000 \
            -e SONAR_TOKEN=${SONAR_TOKEN} \
            -v \$(pwd):/usr/src \
            sonarsource/sonar-scanner-cli \
            -Dsonar.login=${SONAR_TOKEN} \
            -Dsonar.projectKey=devops-capstone-app \
            -Dsonar.sources=./app
        """
      }
    }
    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
      }
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
        // Copy deploy script and run it on remote host via SSH
        sshagent (credentials: ['ec2-ssh']) {
          sh """
            scp -o StrictHostKeyChecking=no deploy/deploy.sh ubuntu@3.6.175.112:/home/ubuntu/deploy.sh
            ssh -o StrictHostKeyChecking=no ubuntu@<EC2_PUBLIC_IP> 'bash /home/ubuntu/deploy.sh ${DOCKER_IMAGE} ${IMAGE_TAG}'
          """
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'app/**', allowEmptyArchive: true
    }
  }
}
