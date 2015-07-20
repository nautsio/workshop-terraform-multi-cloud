# Applied Terraform
### Workflow and Collaboration

!SLIDE
## Resource and plan lifecycles
- Disposable test environments with persistent data
  - Persistent data (S3 bucket): 1 instance, long-lived
  - Test environment: _n_ instances, short-lived

!SUB
## Resource and plan lifecycles (2)
- Dev instances in shared VPC
  - shared VPC: managed by CoreOps team, 1 instance, long-lived
  - Dev instance: managed by Dev team, short-lived, _n_ instances, short-lived

!SLIDE
# Workflow and Collaboration
### Issues and best-practices

!SUB
## Issues
- Creating multiple instances of a plan
- Managing resources with different lifecycles
- Sharing resource/state data between plans and teams
- Collaborating on Ops

!SUB
## Best-practices
- Not a lot of best-practices yet
- Some functionality still missing

!SLIDE
# Part 2
### Workflow and Collaboration

!SUB
## Hands-on
- Work in pairs
- Discuss, prototype, build
- 2 Cases (and 2 Bonus items)
- Time: 45 mins
- Mini-presentation: share your findings (max 2 mins)

!SLIDE
# Part 2a
### Resource and plan lifecycles

!SUB
## Case
You are building a continuous delivery platform, that will be used by multiple product teams to test their web applications on. You also want to be able to develop your platform without interfering with the development process. Also, you want to keep build history from your Jenkins instance.

!SUB
## Assignment
Identify various resources and their lifecycles and create an outline for one or more Terraform plans. You can write the actual Terraform code if you want, but it's not required.

!SLIDE
# Part 2b
### Multiple instances of plan

!SUB
## Case
You have a Terraform plan for a development environment (take any plan from Part 1), but you want to be able to launch several instances of that plan, while keeping track of all of those instances.

!SUB
## Assignment
Identify ways to launch multiple instances of a plan, manage state and plans, and identify pros and cons of each. During the mini-presentation, you will share which method you prefer and why.

!SLIDE
# Bonus items

!SUB
## Collaboration via Terraform
When using Terraform in production, you will most likely work with a team of people managing the plans. Identify ways of collaborating on 'Terraformed' infrastructure, sharing state and plans, and identify pros and cons of each. During the mini-presentation, you will share which method you prefer and why.

!SUB
## Multi-tier deployments
Working from the plan from Part 1f, split the plan into 2 plans, moving the `instances.tf` to its own plan. Make both plans functional, and find a way to use outputs from the 'VPC plan' within the 'Instances plan' to configure the instances to launch in the correct VPC subnet.

Hint: look at `remote_state` in the Terraform documentation.

!SLIDE
# Feedback

!SUB
Did you find an error? Do you feel we didn't touch on subjects we should have? Please send us an email or create a pull request! 

ade@cargonauts.io / benny@cargonauts.io
