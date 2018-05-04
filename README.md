# OpenFaas + Nomad cluster on AWS

This is **bare-bones**, lacking most notably:
  - No SSL (https://)
  - Terraform remote state locking (use e.g. terragrunt)
  - Sane subnet partitioning

Forked and fixed from [terraform-aws-open-faas-nomad](https://github.com/nicholasjackson/terraform-aws-open-faas-nomad)

## Nomad + OpenFaaS

### 1. Set Environment variables for AWS

    export AWS_ACCESS_KEY_ID={{aws_access_key_id}}
    export AWS_SECRET_ACCESS_KEY={{aws_secret_access_key}}
    export AWS_SESSION_TOKEN={{aws_session_token}}

    Prefarably use aws-vault to manage these securely.

### 2. Install Nomad and faas-cli

    brew install faas-cli
    brew install nomad
    brew install terraform

    On GNU\Linux, linuxbrew works as well.

### 3. Create environment

    terraform init
    terraform plan
    terraform apply

    The region will be asked.

### 4. Run OpenFaaS on the Nomad cluster

    export NOMAD_URL=$(terraform output nomad_endpoint)
    nomad run faas.hcl


## Functions

### Deploy a function to OpenFaaS

    export OPENFAAS_URL=$(terraform output openfaas_endpoint)
    cd functions
    #faas-cli new -lang python3 pyfunc
    faas-cli build -f pyfunc.yml
    faas-cli deploy --gateway=$OPENFAAS_URL -f pyfunc.yml

### Test function

    curl -X POST $OPENFAAS_URL/function/pyfunc -d "jee"

### OpenFaas web UI

    open $OPENFAAS_URL
