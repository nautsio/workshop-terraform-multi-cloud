## Automating the modern data center
## Workshop


!SLIDE
# Preparation

!SUB
## You will need

- The workshop repository
- The AWS credentials
- The latest stable version of Terraform
- Configure the `terraform.tfvars` file

!SUB
## Workshop repository
```
$ git clone \
https://github.com/cargonauts/workshop-terraform-multi-cloud.git
```

!SUB
## The AWS credentials
Download the zipfile from: 

-- INSERT IP HERE --

!SUB
## Terraform
Download the latest version from [terraform.io](http://www.terraform.io/)

Mac users can also use Homebrew: 
```
$ brew install terraform
```

!SUB
## TFvars file
Copy the example file: 
```
$ cp terraform.tfvars.example terraform.tfvars
```

!SUB
## Configure the tfvars file
```
aws_access_key = "key"
aws_secret_key = "secret"
aws_region = "eu-west-1"
key_path = "~/.ssh/mykey_rsa"
key_name = "mykey"
```

!SLIDE
# Part 1a: 
## Single instance on Amazon

!SUB
## Apply the Terraform code
```
$ cd part1a
$ terraform apply -var-file=../terraform.tfvars
```

!SUB
## What just happened? 
- Terraform parsed the `variables.tf` and `main.tf` files
- Terraform compared the code to the current state (but there was no state)
- Terraform applied the code and created a single server on AWS

!SLIDE
# Part 1b:
## Update the AMI

!SUB
## Update the AMI
Edit `main.tf` and change the AMI to `ami-971a65e0`.

```

  # Select which AMI to use for the specific region
  ami = "ami-971a65e0"

```

!SUB
## Check what Terraform will do
```
$ terraform plan -var-file=../terraform.tfvars -out part1b.tfplan
```

!SUB
## Apply
If the Terraform plan makes sense to you, apply it:
```
$ terraform apply part1b.tfplan
```
(note that you don't need the `tfvars` file, as that is now part of the plan)

!SUB
## What just happened?
`terraform plan`:
- Terraform parsed the `variables.tf` and `main.tf` files
- Terraform compared the code to the current state, and found that the AMI has changed.
- Terraform proposed to 'fix' this by destroying `aws_instance.web` and re-creating it using the new AMI.
- Terraform saved the plan to `plan1b.tfplan`

!SUB
`terraform apply`:
- Terraform parsed the plan and applied it to the current state

!SLIDE

