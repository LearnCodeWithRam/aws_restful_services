pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "genaiihub24/my-docker:springboot-rest-v2"
    DOCKER_REGISTRY = 'docker.io'  // Docker Hub default registry
    EC2_USER = 'ubuntu'
    EC2_HOST = 'ec2-54-169-205-152.ap-southeast-1.compute.amazonaws.com'
    DOCKER_USERNAME = 'genaiihub24'
    DOCKER_PASSWORD = 'Indore@452010'
    DOCKER_USERNAME = 'your_dockerhub_username'
    DOCKER_PASSWORD = 'your_dockerhub_password'
    SSH_KEY_ID = 'ssh-key'
  }

  stages {
    stage('Build') {
      steps {
        script {
          // Build Docker image
          def dockerImage = docker.build(DOCKER_IMAGE)
        }
      }
    }
    stage('Test') {
      steps {
        // Add your test commands here if any
        echo 'No tests configured'
      }
    }
    stage('Deploy') {
      steps {
        script {
          // Login to Docker registry
          sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin $DOCKER_REGISTRY"
          // Push Docker image
          docker.image(DOCKER_IMAGE).push()
        }
        sshagent([SSH_KEY_ID]) {
          sh """
            ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST <<EOF
            docker pull $DOCKER_IMAGE
            docker stop my-springboot-app || true
            docker rm my-springboot-app || true
            docker run -d -p 8081:8081 --name my-springboot-app $DOCKER_IMAGE
            EOF
          """
        }
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
    