pipeline {
    agent any
    
    tools {
        maven 'maven'
        jdk 'JAVA_HOME'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-token')
        DOCKERHUB_USER = 'endless404'
        IMAGE_NAME = "${DOCKERHUB_USER}/student-management"
        IMAGE_TAG = "latest"
        PIPELINE_NAME = 'ridha_ferchichi_4SAE11'
        KUBE_NAMESPACE = 'devops'
    }

    stages {
        stage('Pipeline Info') {
            steps {
                echo "🚀 Pipeline Name: ${PIPELINE_NAME}"
                echo "📦 Job Name: ${env.JOB_NAME}"
                echo "🔢 Build Number: ${env.BUILD_NUMBER}"
            }
        }

        stage('Check Docker') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/RidhaFerchichi404/ridha_ferchichi_4SAE11.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                sh "echo ${DOCKERHUB_CREDENTIALS} | docker login -u ${DOCKERHUB_USER} --password-stdin"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        echo "🚀 Deploying to Kubernetes namespace: devops"
                        
                        # Use existing kubectl configuration
                        kubectl config use-context minikube
                        
                        # Create namespace if not exists
                        kubectl create namespace devops 2>/dev/null || echo "Namespace exists"
                        
                        # Deploy MySQL
                        echo "📦 Deploying MySQL..."
                        kubectl apply -f k8s/mysql-deployment.yaml -n devops
                        echo "⏳ Waiting for MySQL (30s)..."
                        sleep 30
                        
                        # Check MySQL status
                        echo "🔍 MySQL Status:"
                        kubectl get pods -n devops | grep mysql
                        
                        # Deploy Spring Boot
                        echo "🌐 Deploying Spring Boot..."
                        kubectl apply -f k8s/spring-deployment.yaml -n devops
                        
                        # Wait for deployment
                        echo "⏳ Waiting for Spring Boot startup (150s)..."
                        sleep 150
                        
                        # Verification
                        echo "✅ Verification:"
                        echo "=== PODS ==="
                        kubectl get pods -n devops
                        
                        echo -e "\n=== SERVICES ==="
                        kubectl get svc -n devops
                        
                        echo -e "\n=== SPRING BOOT LOGS (last 30 lines) ==="
                        kubectl logs deployment/spring-app -n devops --tail=30 2>/dev/null || echo "Logs not available yet"
                        
                        # Test the application
                        echo -e "\n=== APPLICATION TEST ==="
                        IP=$(minikube ip 2>/dev/null || echo "192.168.49.2")
                        echo "Minikube IP: $IP"
                        echo "Testing health endpoint..."
                        curl -s "http://$IP:30080/student/actuator/health" || echo "Health endpoint not ready yet"
                        
                        echo -e "\n✅ Deployment completed!"
                    '''
                }
            }
        }
    }

    post {
        always {
            sh '''
                echo "🧹 Cleaning up Docker credentials..."
                docker logout 2>/dev/null || true
            '''
        }
        success {
            echo "✅ Pipeline '${PIPELINE_NAME}' completed successfully!"
        }
        failure {
            echo "❌ Pipeline '${PIPELINE_NAME}' failed."
        }
        unstable {
            echo "⚠️ Pipeline '${PIPELINE_NAME}' is unstable."
        }
    }
}