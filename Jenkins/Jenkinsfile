pipeline {
    agent any

    environment {
        TF_VERSION = "1.7.0"
        TF_CLI_ARGS_apply = "-auto-approve"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ellow0rld/Time-Zone-Converter.git'
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
