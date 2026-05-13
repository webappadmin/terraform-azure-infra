pipeline {
    agent any
    
    environment {
        // Terraform will use Managed Identity automatically
        ARM_USE_MSI = 'true'
        // ARM_SUBSCRIPTION_ID will be auto-detected
    }
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Environment to deploy to'
        )
        
        choice(
            name: 'ACTION',
            choices: ['apply', 'plan', 'destroy'],
            description: 'Terraform action to perform'
        )
        
        string(
            name: 'VM_NAME',
            defaultValue: '',
            description: 'VM name (overrides value in tfvars)'
        )
        
        choice(
            name: 'VM_SIZE',
            choices: ['Standard_B2s', 'Standard_B2ms', 'Standard_D2s_v3', 'Standard_D4s_v3'],
            description: 'VM size (overrides tfvars)'
        )
    }
    
    stages {
        stage('Checkout & Validate') {
            steps {
                checkout scm
                
                script {
                    // Validate environment exists
                    def envPath = "environments/${params.ENVIRONMENT}"
                    if (!fileExists(envPath)) {
                        error("Environment '${params.ENVIRONMENT}' not found. Create environments/${params.ENVIRONMENT}/terraform.tfvars first")
                    }
                    
                    // Display what we're working with
                    sh """
                        echo "=== Environment: ${params.ENVIRONMENT} ==="
                        echo "=== Action: ${params.ACTION} ==="
                        echo "=== TFVars file: environments/${params.ENVIRONMENT}/terraform.tfvars ==="
                        cat environments/${params.ENVIRONMENT}/terraform.tfvars | grep -E "vm_name|vm_size|resource_group_name"
                    """
                }
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    // Create backend config dynamically
                    def backendConfig = """
                        resource_group_name  = "terraform-state-rg"
                        storage_account_name = "tfstate${env.BUILD_TAG.replaceAll('-', '').toLowerCase()}"
                        container_name       = "terraform-state"
                        key                  = "${params.ENVIRONMENT}/terraform.tfstate"
                    """
                    writeFile file: 'backend.hcl', text: backendConfig
                    
                    sh """
                        terraform init \
                            -reconfigure \
                            -backend-config=backend.hcl
                    """
                }
            }
        }
        
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    // Build override variables if needed
                    def varFile = "environments/${params.ENVIRONMENT}/terraform.tfvars"
                    def overrideVars = ""
                    
                    if (params.VM_NAME && params.VM_NAME.trim()) {
                        overrideVars += " -var='vm_name=${params.VM_NAME}'"
                    }
                    if (params.VM_SIZE) {
                        overrideVars += " -var='vm_size=${params.VM_SIZE}'"
                    }
                    
                    sh """
                        terraform plan \
                            -var-file="${varFile}" \
                            ${overrideVars} \
                            -out=tfplan \
                            -input=false
                    """
                }
            }
        }
        
        stage('Terraform Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                script {
                    // Production approval
                    if (params.ENVIRONMENT == 'prod') {
                        input message: "⚠️ Deploy to PRODUCTION environment? ⚠️", 
                              ok: "Yes, deploy to production"
                    }
                    
                    sh 'terraform apply -auto-approve tfplan'
                    
                    // Capture and display outputs
                    def publicIp = sh(script: "terraform output -raw vm_public_ip 2>/dev/null || echo 'Not available'", returnStdout: true).trim()
                    def vmName = sh(script: "terraform output -raw vm_name 2>/dev/null || echo '${params.VM_NAME}'", returnStdout: true).trim()
                    
                    echo """
                    ========================================
                    ✅ DEPLOYMENT SUCCESSFUL!
                    ========================================
                    Environment: ${params.ENVIRONMENT}
                    VM Name: ${vmName}
                    Public IP: ${publicIp}
                    SSH Command: ssh azureuser@${publicIp}
                    ========================================
                    """
                }
            }
        }
        
        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                script {
                    input message: "⚠️ DESTROY ${params.ENVIRONMENT} environment? This cannot be undone! ⚠️", 
                          ok: "Yes, destroy everything"
                    
                    def varFile = "environments/${params.ENVIRONMENT}/terraform.tfvars"
                    sh """
                        terraform destroy \
                            -var-file="${varFile}" \
                            -auto-approve
                    """
                }
            }
        }
    }
    
    post {
        always {
            // Clean up workspace
            cleanWs()
        }
        failure {
            echo "❌ Pipeline failed for ${params.ENVIRONMENT}"
            // Optional: Send notification
        }
        success {
            echo "✅ Pipeline completed for ${params.ENVIRONMENT}"
        }
    }
}