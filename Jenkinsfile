import groovy.json.JsonSlurperClassic
pipeline {
  agent any
  parameters {
    choice(name: 'environment', choices: ['full', 'down'], description: "State of resources to deploy.")
    booleanParam(name: 'rebuildami', defaultValue: false, description: 'Rebuild AMI?')
  }
  environment {
    PATH = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin"
  }
  stages {
    stage('Setup') {
      steps {
        script {
          echo "Prerequisite Setup"
          sh "mkdir tmp"
          echo "Declaring Variables"
          switch (environment) {
            case 'full':
              role = "arn:aws:iam::103348857345:role/Admin"
              session = "jenkins-${environment}-deployment"
              region = "eu-west-1"
              break
            case 'down':
              role = "arn:aws:iam::103348857345:role/Admin"
              session = "jenkins-${environment}-deployment"
              region = "eu-west-1"
              break
          }
          echo "Assuming Role"
          sh("aws sts assume-role \
            --role-arn ${role} \
            --role-session-name ${session} \
            --region ${region} \
            > tmp/assume-role-output.json")
          echo "Preparing Credentials"
          credsJson = readFile("${WORKSPACE}/tmp/assume-role-output.json")
          credsObj = new groovy.json.JsonSlurperClassic().parseText(credsJson)
        }
      }
    }
    stage('Provision') {
      steps {
        script {
          if(params.rebuildami) {
            echo "Provisioning AMI"
            withEnv(["AWS_ACCESS_KEY_ID=${credsObj.Credentials.AccessKeyId}", "AWS_SECRET_ACCESS_KEY=${credsObj.Credentials.SecretAccessKey}", "AWS_SESSION_TOKEN=${credsObj.Credentials.SessionToken}"]) {
              sh("packer build -color=false ${workspace}/packer/${environment}.json")
            }
          } else {
            echo "Skipping AMI Rebuild"
          }
        }
      }
    }
    stage('Deploy') {
      steps {
        dir("${workspace}/terraform/deploys/${environment}-data") {
          echo "Initialising Terraform"
          sh("terraform init -input=false -no-color")
          sh("terraform plan -out=plan.out -no-color -var environment=${environment}")
          echo "Deploying Terraform"
          sh("terraform apply plan.out -auto-approve -no-color ")
        }
      }
    }
  }
  post {
    cleanup {
      script {
        echo 'End of Jenkinsfile'
        sh("rm -rf tmp")
        cleanWs()
      }
    }
  }
}
