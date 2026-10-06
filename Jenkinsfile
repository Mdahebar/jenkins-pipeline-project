pipeline {
    agent any

    environment {
        APP_NAME = 'DevOps-Core-App'
    }

    stages {
        stage('Checkout & Verify') {
            steps {
                echo "=== Step 1: Code fetched via SCM ==="
                sh '''
                    echo "Current directory:"
                    pwd
                    echo "Cloned repository files:"
                    ls -la
                '''
            }
        }

        stage('Build Simulation') {
            steps {
                echo "=== Step 2: Building ${env.APP_NAME} ==="
                sh '''
                    echo "Compiling application binaries..."
                    mkdir -p dist
                    echo "App Version: 1.0.0" > dist/app.info
                    cat dist/app.info
                '''
            }
        }

        stage('Unit Testing') {
            steps {
                echo "=== Step 3: Running automated validation ==="
                sh '''
                    if [ -d dist ]; then
                        echo "Build directory exists! Validation Passed."
                    else
                        echo "Build failed!"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline run completed."
        }
        success {
            echo "Success: SCM Pipeline executed flawlessly!"
        }
    }
}
