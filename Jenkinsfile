pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
        DEPLOY_USER = 'ubuntu'
        DEPLOY_HOST = '13.201.1.52'
        DEPLOY_PATH = '/home/ubuntu/jenkins' // Remote path where the app will be deployed
        SSH_KEY = credentials('creds') // Jenkins credential ID for SSH key
    }

    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    sh 'npm install'
                }
            }
        }

        stage('Build the App') {
            steps {
                script {
                    sh 'npm run build'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'npm test'
                }
            }
        }

        stage('Deploy to Server') {
            steps {
                script {
                    // Copy files to the server
                    sh """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${DEPLOY_USER}@${DEPLOY_HOST} 'mkdir -p ${DEPLOY_PATH}'
                        rsync -avz --delete -e "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no" ./ ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}
                    """

                    // Restart the application on the server
                    sh """
                        ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${DEPLOY_USER}@${DEPLOY_HOST} 'cd ${DEPLOY_PATH} && npm install --production && pm2 restart all'
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}

