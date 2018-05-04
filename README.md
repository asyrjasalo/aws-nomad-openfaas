OpenFaaS in Nomad cluster on AWS
================================

This is **bare-bones**, lacking everything extra and most notably:
  - No https:// for OpenFaaS and Nomad (TODO: maybe use an API Gateway?)
  - Terraform remote state locking (use e.g. [terragrunt](https://github.com/gruntwork-io/terragrunt))

Forked and fixed from [terraform-aws-open-faas-nomad](https://github.com/nicholasjackson/terraform-aws-open-faas-nomad), `faas.hcl` using [faas-nomad/nomad_job_files/faas.hcl](https://github.com/hashicorp/faas-nomad/blob/master/nomad_job_files/faas.hcl) as the base.


Setup
-----

### 1. Export the AWS environment variables

    export AWS_ACCESS_KEY_ID={{aws_access_key_id}}
    export AWS_SECRET_ACCESS_KEY={{aws_secret_access_key}}
    export AWS_SESSION_TOKEN={{aws_session_token}}

Tip: Prefer [aws-vault](https://github.com/99designs/aws-vault) to store these in keyrings (OS X, Linux distros).

### 2. Install the command-line tools

    brew install faas-cli
    brew install nomad
    brew install terraform

Tip: On GNU\Linux, try [linuxbrew](http://linuxbrew.sh).

### 3. Fetch the Terraform module deps

    terraform init

### 4. Plan and apply - the region is asked

    terraform plan
    terraform apply

### 5. Launch OpenFaaS in Nomad

    export NOMAD_ADDR=$(terraform output nomad_endpoint)
    nomad run faas.hcl


Functions
---------

### Create a new function

    export OPENFAAS_URL=$(terraform output openfaas_endpoint)
    cd functions

I already committed this to the repository:

    faas-cli new -lang python3 pyfunc

Change `image` in `.yml` to include username for [DockerHub](https://hub.docker.com), or prepend the private Docker registry url.

Argument `-lang` can be `dockerfile`, to run any Docker container as a function:

### Build the Docker image

    faas-cli build -f pyfunc.yml

### Push Docker image to Docker registry

    faas-cli push -f pyfunc.yml

Make the image public in DockerHub, to get OpenFaaS to fetch it.
(TODO: have some privacy)

### Deploy to OpenFaaS

    faas-cli deploy --gateway=$OPENFAAS_URL -f pyfunc.yml

### Test the function

    curl -X POST "${OPENFAAS_URL}/function/pyfunc" -d "💣"

### Check the UIs

    open $OPENFAAS_URL
    nomad ui
