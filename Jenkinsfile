pipeline {

    agent any

    environment {
        DOCKER_REPO = 'mdahebar'
        IMAGE_NAME = 'devops-app'
    }

    stages {

        stage('Checkout') {
            steps {
                echo "=== Step 1: Checking out source code ==="
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "=== Step 2: Building Docker Image ==="
                sh "docker build -t ${env.DOCKER_REPO}/${env.IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Test Container') {
            steps {
                echo "=== Step 3: Testing Docker Container ==="

                sh """
                    docker rm -f test-container-${BUILD_NUMBER} || true
                    docker run -d \
                        --name test-container-${BUILD_NUMBER} \
                        -p 8081:80 \
                        ${env.DOCKER_REPO}/${env.IMAGE_NAME}:${BUILD_NUMBER}

                    sleep 5

                    curl -s http://localhost:8081 | grep 'DevOps CI/CD Pipeline'
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "=== Step 4: Pushing Image to Docker Hub ==="

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {

                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin

                        docker push ${DOCKER_REPO}/${IMAGE_NAME}:${BUILD_NUMBER}

                        docker tag \
                            ${DOCKER_REPO}/${IMAGE_NAME}:${BUILD_NUMBER} \
                            ${DOCKER_REPO}/${IMAGE_NAME}:latest

                        docker push ${DOCKER_REPO}/${IMAGE_NAME}:latest

                        docker logout
                    '''
                }
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

    post {
        always {
            echo "=== Cleaning up test container ==="
            sh "docker rm -f test-container-${BUILD_NUMBER} || true"
        }

        success {
            echo "=== CI/CD Pipeline Completed Successfully! ==="
        }

        failure {
            echo "=== CI/CD Pipeline Failed! Check the logs. ==="
        }
    }
}
