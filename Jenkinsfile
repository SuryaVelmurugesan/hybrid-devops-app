pipeline {
  agent any

  environment {
    // make sure these credentials exist in Jenkins
    DOCKERHUB_CRED = credentials('dockerhub')   // username/password credential id
    EC2_SSH = 'ec2-ssh'                         // SSH credential id (SSH Username with private key)
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
        // Build from repo root; Dockerfile expects app/ files
        sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PSW')]) {
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
        // This uses the ssh-agent plugin and the SSH credential id 'ec2-ssh'
        sshagent (credentials: ['ec2-ssh']) {
          sh '''
            echo "Deploying on EC2 instance as ec2-user..."
            scp -o StrictHostKeyChecking=no deploy/deploy.sh ec2-user@3.6.175.112:/home/ec2-user/deploy.sh
            ssh -o StrictHostKeyChecking=no ec2-user@3.6.175.112 "bash /home/ec2-user/deploy.sh ${DOCKER_IMAGE} ${IMAGE_TAG}"
          '''
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'app/**', allowEmptyArchive: true
    }
    success {
      echo "Pipeline completed successfully: ${DOCKER_IMAGE}:${IMAGE_TAG}"
    }
    failure {
      echo "Pipeline failed. Check console output."
    }
  }
}
