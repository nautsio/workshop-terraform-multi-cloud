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

https://tools.bennycornelissen.nl/openkitchen.zip

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
$ cd part1c
$ cp ../part1a/terraform.tfstate .
$ terraform plan -var-file=../terraform.tfvars
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
## Apply 
Wait. Why would I apply when Terraform isn't going to change anything? Well, remember that `outputs.tf` file you saw earlier? 

```
$ terraform apply -var-file=../terraform.tfvars
```

!SUB
## Destroy 
Let's clean up our instance:

```
$ terraform destroy -var-file=../terraform.tfvars
```

!SLIDE
# Part 1d
### Provisioning an instance

!SUB
## Provisioners
Terraform allows you to provision your instances in various ways: 
- Remote execution (command/script run on the instance)
- Local execution (command/script run on your local machine)
- File (copy a file to the instance)
- Chef (use Chef to configure the instance)
- Userdata (depending on instance type and AMI)

!SUB
## Simple provisioning
In this part we will provision our instance using `remote-exec`: 
```
...
  connection {
    user = "admin"
    key_file = "${var.key_path}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apache2",
      "sudo service apache2 restart"
    ]
  }
...
```

!SUB
## Apply
```
$ cd part1d
$ terraform apply -var-file=../terraform.tfvars
```

(It may take a minute or so to connect to the instance. If it doesn't work, check if you have set the path to your private key correctly in `terraform.tfvars`)

!SUB
## Did it work? 
Enter the IP address from the Terraform output in your browser, or if you have cURL installed, run:

```
$ curl -I $(terraform output instance_ip)
```

!SUB
## Do not use this! 
If you were unlucky, the remote-provisioning did not work. This happens sometimes with AWS. That is why we consider `remote-exec` to be an unreliable method of provisioning. A better alternative would be using `user_data` to configure the host, or to create a pre-provisioned AMI using Packer.

!SUB
## Destroy 
Let's clean up again:

```
$ terraform destroy -var-file=../terraform.tfvars
```

!SLIDE
# Part 1e
### Add a VPC (Virtual Private Cloud)

!SUB
## VPC
If you do not know yet what an Amazon VPC is, go ahead and take a look [here](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Introduction.html). But to keep things simple for now, we already have all the necessary code in place. Take a look at the `main.tf` file to get an idea of what we are building. 

!SUB
## Apply
By now you probably know what to do... ;-) 

If not: 
```
$ cd part1e
$ terraform apply -var-file=../terraform.tfvars
```

!SUB
## This plan does not make sense!
You are completely right. However, this plan is for demonstration purposes only. ;-)

!SLIDE
# Part 1f
### Using multiple files for your plan

!SUB
## Why should I do this? 
For relatively small plans, just having `variables.tf` and `main.tf` will probably work fine. However, if your plans start to grow, it may be a good idea to split your plans into multiple files, or later even use modules (but those are not on the menu today). Using multiple files allows you to keep your code readable. 

!SUB
## Split all the things
In this part, we have taken the Terraform plan from the previous part, and split it into multiple files. This works because Terraform looks at all the `.tf` files in the give directory at runtime. 

Take a look at the code. 

!SUB
## Let's try it! 
This plan should execute exactly like the previous plan. Let's see if it does: 

```
cd part1f
cp ../part1e/terraform.tfstate .
terraform plan -var-file=../terraform.tfvars
```

!SUB
## Expectation:
There should be no changes. 

!SUB
## Run the plan anyway
If you want to run the plan anyway, to see if it works: 
```
$ terraform destroy -var-file=../terraform.tfvars
$ terraform apply -var-file=../terraform.tfvars
```

!SLIDE
# Already done?

!SLIDE
# Bonus items
### For the brave...

!SUB
## Multiple instances inside a VPC
Take the plan from part1f, and change it so there are multiple instances of `aws_instance.web`. 

Hint: you need to change something about the outputs too. 

!SUB
## Add Route53 DNS
Add a Route53 zone `openkitchen.int` and add records for the instances created in the previous bonus item.

!SUB
## Load balancing
Add load balancing for your webservers. There are multiple ways to solve this: 
- Elastic IP + HAProxy instance
- Elastic Load Balancer 
- something else? (surprise us!)

!SUB
## Add a cloud service of your choice
Do you want to configure an external domain, for instance using Cloudflare? Or do you want to run some instances on DigitalOcean? Or both? 

We included a Cloudflare token in the credentials zipfile. You can create a subdomain on `openkitchen.io`.  

