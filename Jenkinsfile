pipeline {
    agent any

    parameters {
        string(name: 'WORKSPACE', defaultValue: 'development', description:'worspace to use in Terraform')
        password (name: 'AWS_ACCESS_KEY_ID', defaultValue: 'AKIATQ2TQYVE5WMEMFK2')
        password (name: 'AWS_SECRET_ACCESS_KEY', defaultValue: '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')
    }
    environment {
        TF_IN_AUTOMATION = "true"
        NETWORKING_ACCESS_KEY = "${params.AWS_ACCESS_KEY_ID}"
        NETWORKING_SECRET_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
        TF_PATH = "/var/lib/jenkins/workspace/JenkinsPipelineNetwork_main"
    }
    stages {
        stage('GitClone') {
          steps {
            git url: 'https://github.com/alanzha0598/JenkinsPipelineNetworkPublic.git', branch: 'main'
            sh "echo \$PWD"
          }
        }
        stage('NetworkInit'){
            steps {
                dir('/var/lib/jenkins/workspace/JenkinsPipelineNetwork_main'){
                    sh 'terraform --version'
                    sh "terraform init -input=false --backend-config='access_key=$NETWORKING_ACCESS_KEY' --backend-config='secret_key=$NETWORKING_SECRET_KEY' "                    
                    sh "echo \$PWD"
                    sh "whoami"
                }
            }
        }
        stage('NetworkPlan'){
            steps {
                dir('$TF_PATH'){
                    script {
                        try {
                           sh "terraform workspace new ${params.WORKSPACE}"
                        } catch (err) {
                            sh "terraform workspace select ${params.WORKSPACE}"
                        }
                        sh "terraform plan -input=false -out terraform-networking.tfplan -var 'aws_access_key=$NETWORKING_ACCESS_KEY' -var 'aws_secret_key=$NETWORKING_SECRET_KEY';echo \$? > status"
                        stash name: "terraform-networking-plan", includes: "terraform-networking.tfplan"
                    }
                }
            }
        }
        stage('NetworkApply'){
            steps {
                script{
                    def apply = false
                    try {
                        input message: 'confirm apply', ok: 'Apply Config'
                        apply = true
                    } catch (err) {
                        apply = false
                        dir('$TF_PATH'){
                            sh "terraform destroy -force  -var 'aws_access_key=$NETWORKING_ACCESS_KEY' -var 'aws_secret_key=$NETWORKING_SECRET_KEY'"
                        }
                        currentBuild.result = 'UNSTABLE'
                    }
                    if(apply){
                        dir('$TF_PATH'){
                            unstash "terraform-networking-plan"
                            sh 'terraform apply -input=false terraform-networking.tfplan'
                        }
                    }
                }
            }
        }
    }
}
