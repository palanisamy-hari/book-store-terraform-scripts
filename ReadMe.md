## Book Store Application - Terraform scripts

This terraform script is to create an infrastructure for the book store application deployment and testing.

The script will deploy these items to AWS:
1. Concourse CI tool
2. Selenium Grid
3. Book Store Application Blue with Green Deployment structure.

## Execution

1. ```terraform init```

    This command performs several different initialization steps in order to prepare the current working directory for use with Terraform. More details on these are in the sections below, but in most cases it is not necessary to worry about these individual steps.
   

2. ```terraform plan```
   
    The terraform plan command creates an execution plan. By default, creating a plan consists of:

    Reading the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
Comparing the current configuration to the prior state and noting any differences.
Proposing a set of change actions that should, if applied, make the remote objects match the configuration
   
1. ```terraform apply```

   The terraform apply command executes the actions proposed in a Terraform plan. The most straightforward way to use terraform apply is to run it without any arguments at all, in which case it will automatically create a new execution plan (as if you had run terraform plan) and then prompt you to approve that plan, before taking the indicated actions

This project contains two different terraform scripts.

1.  Setup Concourse and Selenium grid - Execute [main.tf](main.tf)
2.  Setup Blue-Green Deployment - Execute [blue-green main.tf](blue-green/main.tf)