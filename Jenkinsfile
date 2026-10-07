pipeline {

    agent any

    environment {
        DOCKER_REPO = 'mdahebar'
        IMAGE_NAME = 'devops-app'
    }

    stages {

        stage('Checkout') {
            steps {
                // checkout code
            }
        }

        stage('Build Docker Image') {
            steps {
                // docker build
            }
        }

        stage('Test Container') {
            steps {
                // test
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // docker push
            }
        }

        stage('Deploy to Production') {
            steps {
                echo "=== Step 5: Deploying Container to Production (Port 80) ==="

                sh "docker pull ${env.DOCKER_REPO}/${env.IMAGE_NAME}:latest"

                sh "docker rm -f prod-container || true"

                sh "docker run -d -p 80:80 --name prod-container ${env.DOCKER_REPO}/${env.IMAGE_NAME}:latest"

                echo "Application successfully deployed to Production!"
            }
        }

    }
}
