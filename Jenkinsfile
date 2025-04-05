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
                    string(credentialsId: '4a2d3a89-c4a3-4a18-83f2-389fb5b91ef2', variable: 'aws-access-key-id'),
                    string(credentialsId: '990a7f71-4acb-40e8-bdbc-e14d4fa089c2', variable: 'aws-secret-access-key')
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
