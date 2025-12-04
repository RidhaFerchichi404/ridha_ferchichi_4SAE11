pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-token')  // Jenkins credential ID for your Docker Hub token
        DOCKERHUB_USER = 'endless404'                           // Your Docker Hub username
        IMAGE_NAME = "${DOCKERHUB_USER}/student-management"     // Docker image name on Docker Hub
        IMAGE_TAG = "latest"                                    // You can replace 'latest' with version or branch name
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning the repository...'
                git branch: 'main', url: 'https://github.com/RidhaFerchichi404/ridha_ferchichi_4SAE11.git'
            }
        }

	stage('Build') {
    	    steps {
        	echo 'Building the Maven project (skipping tests)...'
        	sh 'mvn clean package -DskipTests'
    	    }
	}


        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo 'Logging in to Docker Hub...'
                sh "echo ${DOCKERHUB_CREDENTIALS} | docker login -u ${DOCKERHUB_USER} --password-stdin"
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo '✅ Build and Docker push completed successfully!'
        }
        failure {
            echo '❌ Build or push failed. Please check logs.'
        }
        always {
            echo 'Cleaning up Docker login...'
            sh "docker logout"
        }
    }
}
