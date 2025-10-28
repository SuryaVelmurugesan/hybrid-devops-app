pipeline {
  agent any

  environment {
    DOCKERHUB_CRED = credentials('dockerhub')
    EC2_SSH = 'ec2-ssh'
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
          sh '''
            if [ -f package-lock.json ]; then
              npm ci
            else
              npm install
            fi
            npm test || true
          '''
        }
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
          sh '''
            echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
            docker logout
          '''
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        sshagent (credentials: ['ec2-ssh']) {
          sh '''
            echo "Deploying on EC2 instance..."
            scp -o StrictHostKeyChecking=no deploy/deploy.sh ubuntu@3.6.175.112:/home/ubuntu/deploy.sh
            ssh -o StrictHostKeyChecking=no ubuntu@3.6.175.112 "bash /home/ubuntu/deploy.sh ${DOCKER_IMAGE} ${IMAGE_TAG}"
          '''
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
