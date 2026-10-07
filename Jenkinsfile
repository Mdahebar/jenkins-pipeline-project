pipeline {
    agent any

    environment {
        APP_NAME    = 'DevOps-Core-App'
        IMAGE_NAME  = 'devops-app'
        DOCKER_REPO = 'mdahebar'
    }

    stages {
        stage('Checkout & Verify') {
            steps {
                echo "=== Step 1: Code fetched via SCM ==="
                sh 'ls -la'
            }
        }

        stage('Docker Build') {
            steps {
                echo "=== Step 2: Building Docker Image for Build #${env.BUILD_NUMBER} ==="
                sh "docker build -t ${env.DOCKER_REPO}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        stage('Docker Test & Validate') {
            steps {
                echo "=== Step 3: Running Container & Validating Response ==="
                sh "docker run -d -p 8081:80 --name test-container-${env.BUILD_NUMBER} ${env.DOCKER_REPO}/${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                sh "sleep 3"
                sh "curl -s http://localhost:8081 | grep 'DevOps CI/CD Pipeline'"
                echo "Container test passed successfully!"
            }
        }

        stage('Docker Hub Push') {
            steps {
                echo "=== Step 4: Authenticating & Pushing to Docker Hub ==="
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${env.DOCKER_REPO}/${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker tag ${env.DOCKER_REPO}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} ${env.DOCKER_REPO}/${env.IMAGE_NAME}:latest"
                    sh "docker push ${env.DOCKER_REPO}/${env.IMAGE_NAME}:latest"
                    sh "docker logout"
                }
            }
        }
    }

    post {
        always {
            echo "=== Step 5: Cleanup Testing Container ==="
            sh "docker rm -f test-container-${env.BUILD_NUMBER} || true"
        }
        success {
            echo "Success: Docker image ${env.DOCKER_REPO}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} pushed to Docker Hub!"
        }
        failure {
            echo "Failure: Docker CI/CD pipeline failed!"
        }
    }
}
