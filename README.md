# aws-rds-snapshot-replication
Python and shell scripts to automate RDS snapshot creation and cross-region replication in AWS cloud environments. 

These scripts are designed to be run from a CI/CD node like Jenkins. Therefore, you will need to have an IAM policy with proper permissions for the jenkins user to be able to perform RDS specific actions. A sample of a custom policy has been added to this repo. 
