pipeline {
    agent any
    
    environment {
        PROJECT_ID = "terraform-gcp-506723"
        IMAGE_NAME = "gcr.io/${env.PROJECT_ID}/vois-app"
        CREDENTIALS_ID = "gcp-sa-key"
    }
    
    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('2. Setup Tools & Build') {
            steps {
                script {
                    withCredentials([file(credentialsId: env.CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh '''
                            # تحميل gcloud كـ Binary خفيف لو مش موجود في Workspace
                            if [ ! -f ./google-cloud-sdk/bin/gcloud ]; then
                                echo "Downloading gcloud CLI binary..."
                                curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-470.0.0-linux-x86_64.tar.gz
                                tar -xzf google-cloud-cli-470.0.0-linux-x86_64.tar.gz
                                ./google-cloud-sdk/install.sh --quiet --usage-reporting=false --path-update=false
                            fi

                            # إضافة المسار المحلي للـ PATH
                            export PATH=$PWD/google-cloud-sdk/bin:$PATH

                            # تنفيذ الأوامر
                            gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                            gcloud auth configure-docker --quiet
                            
                            docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                            docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
        
        stage('3. Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: env.CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh '''
                            export PATH=$PWD/google-cloud-sdk/bin:$PATH
                            gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                            
                            # تثبيت kubectl محلياً لو مش موجود
                            if ! command -v kubectl &> /dev/null; then
                                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                                chmod +x kubectl
                                mkdir -p ~/.local/bin
                                mv kubectl ~/.local/bin/
                                export PATH=$PATH:~/.local/bin
                            fi

                            kubectl set image deployment/vois-app vois-app=${IMAGE_NAME}:${BUILD_NUMBER} -n production
                        '''
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully! App is deployed.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}