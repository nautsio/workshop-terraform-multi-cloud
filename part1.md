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
key_path = "/path/to/openkitchen_rsa"
key_name = "openkitchen_rsa"
```

!SLIDE
# Part 1a
### Single instance on Amazon

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
# Part 1b
### Update the AMI

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
- Terraform parsed the plan and applied it to the current state:
  - Destroy `aws_instance.web`
  - Create new `aws_instance.web` using new AMI

!SLIDE
# Part 1c
### Use variables
Most of the resource attributes have been hard-coded so far, but it is highly recommended to use variables whenever possible. In this part, we have rewritten the code from the previous part to use variables whenever possible.

!SUB
## Let's see what has changed
Take a look at the code and see what has been changed. What is that new file, `outputs.tf`?

!SUB
## Is our plan still the same?
Let's copy the state from our previous plan, and find out.
```
cd part1c
cp ../part1a/terraform.tfstate .
terraform plan -var-file=../terraform.tfvars
```

!SUB
## Expectation:
```
Refreshing Terraform state prior to plan...

aws_instance.web: Refreshing state... (ID: i-60e8f3ca)

No changes. Infrastructure is up-to-date. This means that Terraform
could not detect any differences between your configuration and
the real physical resources that exist. As a result, Terraform
doesn't need to do anything.
```

!SUB

