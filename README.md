# terraform
terraform code example

# Project Tree
```
.
├── 02
│   ├── README.md
│   ├── data-output
│   │   └── learn-terraform-outputs
│   │       ├── LICENSE
│   │       ├── main.tf
│   │       ├── modules
│   │       │   └── aws-instance
│   │       │       ├── main.tf
│   │       │       ├── outputs.tf
│   │       │       └── variables.tf
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       ├── terraform.tfstate
│   │       ├── terraform.tfstate.backup
│   │       └── variables.tf
│   ├── data-source
│   │   ├── learn-terraform-data-sources-app
│   │   │   ├── LICENSE
│   │   │   ├── README.md
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── terraform.tf
│   │   │   ├── terraform.tfstate
│   │   │   └── variables.tf
│   │   └── learn-terraform-data-sources-vpc
│   │       ├── LICENSE
│   │       ├── README.md
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       ├── terraform.tfstate
│   │       ├── terraform.tfstate.backup
│   │       └── variables.tf
│   ├── lab01
│   │   ├── main.tf
│   │   ├── terraform.tfstate
│   │   └── terraform.tfstate.backup
│   ├── lab02
│   │   ├── ec2.tf
│   │   ├── terraform.tfstate
│   │   └── terraform.tfstate.backup
│   ├── one-server
│   │   ├── main.tf
│   │   ├── terraform.tfstate
│   │   └── terraform.tfstate.backup
│   ├── one-web-server-with-vars
│   │   └── learn-terraform-variables
│   │       ├── main.tf
│   │       ├── modules
│   │       │   └── aws-instance
│   │       │       ├── main.tf
│   │       │       ├── outputs.tf
│   │       │       └── variables.tf
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       ├── terraform.tfstate
│   │       ├── terraform.tfstate.backup
│   │       ├── terraform.tfvars
│   │       └── variables.tf
│   ├── one-webserver
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── terraform.tfstate
│   │   ├── terraform.tfstate.backup
│   │   └── variables.tf
│   └── webserver-cluster
│       ├── main.tf
│       ├── output.tf
│       ├── terraform.tfstate
│       ├── terraform.tfstate.backup
│       └── variables.tf
├── 03
│   ├── README.md
│   ├── elb-web-db
│   │   ├── global
│   │   │   └── s3
│   │   │       ├── main.tf
│   │   │       └── output.tf
│   │   └── stage
│   │       ├── data-stores
│   │       │   └── mysql
│   │       │       ├── db_credentials.sh
│   │       │       ├── main.tf
│   │       │       ├── output.tf
│   │       │       ├── terraform.tfstate
│   │       │       ├── terraform.tfstate.backup
│   │       │       └── variables.tf
│   │       └── services
│   │           └── webserver-cluster
│   │               ├── main.tf
│   │               ├── output.tf
│   │               ├── terraform.tfstate
│   │               ├── terraform.tfstate.backup
│   │               └── user-data.sh
│   ├── global
│   │   ├── instance
│   │   │   └── main.tf
│   │   └── s3
│   │       ├── main.tf
│   │       └── output.tf
│   └── troubleshooting
│       └── learn-terraform-troubleshooting
│           ├── LICENSE
│           ├── README.md
│           ├── logs.txt
│           ├── main.tf
│           ├── outputs.tf
│           ├── terraform.tfstate
│           ├── terraform.tfstate.backup
│           ├── terraform.tfvars
│           └── variables.tf
├── 04
│   ├── module-create
│   │   └── learn-terraform-modules-create
│   │       ├── LICENSE
│   │       ├── README.md
│   │       ├── main.tf
│   │       ├── modules
│   │       │   └── aws-s3-static-website-bucket
│   │       │       ├── LICENSE
│   │       │       ├── README.md
│   │       │       ├── main.tf
│   │       │       ├── outputs.tf
│   │       │       ├── variables.tf
│   │       │       └── www
│   │       │           ├── error.html
│   │       │           └── index.html
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       ├── terraform.tfstate
│   │       ├── terraform.tfstate.backup
│   │       └── variables.tf
│   ├── module-overview
│   │   └── learn-terraform-modules-use
│   │       ├── LICENSE
│   │       ├── README.md
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       ├── terraform.tfstate
│   │       ├── terraform.tfstate.backup
│   │       └── variables.tf
│   └── vpc-create
│       ├── dev
│       │   ├── main.tf
│       │   ├── provider.tf
│       │   ├── terraform.tfstate
│       │   ├── terraform.tfstate.backup
│       │   └── variables.tf
│       ├── modules
│       │   ├── ec2
│       │   │   ├── main.tf
│       │   │   ├── outputs.tf
│       │   │   └── variables.tf
│       │   └── vpc
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       └── variables.tf
│       ├── prod
│       └── terraform.tfstate
├── README.md
├── covertf
│   ├── README.md
│   ├── main.tf
│   ├── origin.yaml
│   ├── output.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
└── miniproject1
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── sshconfig.tpl
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    ├── userdata.tpl
    └── variables.tf

47 directories, 131 files
```