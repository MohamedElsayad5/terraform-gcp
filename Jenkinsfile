pipeline {
    agent any
    
    stages {
        stage('1. Checkout Code') {
            steps {
                echo 'Pulling code from repository...'
                checkout scm
            }
        }
        
        stage('2. Build Docker Image') {
            steps {
                echo 'Building Docker image for vois-app...'
                script {
                    appImage = docker.build("gcr.io/${env.PROJECT_ID}/vois-app:${env.BUILD_NUMBER}")
                }
            }
        }
        
        stage('3. Deploy to Kubernetes') {
            steps {
                echo 'Deploying application to production namespace...'
                sh "kubectl set image deployment/vois-app vois-app=gcr.io/${env.PROJECT_ID}/vois-app:${env.BUILD_NUMBER} -n production"
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully! App is up and running.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}