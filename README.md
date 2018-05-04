OpenFaas in Nomad cluster on AWS
================================

This is **bare-bones**, lacking everything extra and most notably:
  - No https:// for OpenFaas and Nomad (TODO: maybe use an API Gateway?)
  - Terraform remote state locking (use e.g. [terragrunt](https://github.com/gruntwork-io/terragrunt))

Forked and fixed from [terraform-aws-open-faas-nomad](https://github.com/nicholasjackson/terraform-aws-open-faas-nomad), `faas.hcl` using [faas-nomad/nomad_job_files/faas.hcl](https://github.com/hashicorp/faas-nomad/blob/master/nomad_job_files/faas.hcl) as the base.


Setup
-----

### 1. Set Environment variables for AWS

    export AWS_ACCESS_KEY_ID={{aws_access_key_id}}
    export AWS_SECRET_ACCESS_KEY={{aws_secret_access_key}}
    export AWS_SESSION_TOKEN={{aws_session_token}}

Tip: Prefer [aws-vault](https://github.com/99designs/aws-vault) to store these safely.

### 2. Install Nomad and faas-cli

    brew install faas-cli
    brew install nomad
    brew install terraform

Tip: On GNU\Linux, try [linuxbrew](http://linuxbrew.sh).

### 3. Fetch terraform dependencies

    terraform init

### 4. Plan and apply (the region is asked)

    terraform plan
    terraform apply

### 5. Launch OpenFaaS using Nomad

    export NOMAD_ADDR=$(terraform output nomad_endpoint)
    nomad run faas.hcl


Functions
---------

### Deploy functions to OpenFaaS

    export OPENFAAS_URL=$(terraform output openfaas_endpoint)
    cd functions

### Create a new function (already done)

Language can be given as `dockerfile` to run any Docker container:

    faas-cli new -lang python3 pyfunc

Change `image` in `.yml` to include username for [DockerHub](https://hub.docker.com), or prepend the private Docker registry url.

### Build the Docker image

    faas-cli build -f pyfunc.yml

### Push it to Docker registry

    faas-cli push -f pyfunc.yml

Make the image public to be able for OpenFaas to fetch it
(TODO: have some privacy)

### Deploy to OpenFaaS

    faas-cli deploy --gateway=$OPENFAAS_URL -f pyfunc.yml

### Test the function

    curl -X POST "${OPENFAAS_URL}function/pyfunc" -d "💣"

### Check the UIs

    open $OPENFAAS_URL
    nomad ui
