pipeline {
    agent any

    environment {
        TF_VERSION = "1.7.0"
        TF_CLI_ARGS_apply = "-auto-approve"
        AWS_REGION = "us-east-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ellow0rld/Time-Zone-Converter.git'
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    echo "AWS credentials injected for us-east-1"
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Plan Terraform Changes') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Terraform Changes') {
            steps {
                sh 'terraform apply tfplan'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'terraform.tfstate', fingerprint: true
        }
        failure {
            echo "Terraform deployment failed!"
        }
        success {
            echo "Terraform deployment successful!"
        }
    }
}
