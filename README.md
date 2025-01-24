.
├── 02
│   ├── README.md
│   ├── data-output
│   │   └── learn-terraform-outputs
│   │       ├── LICENSE
│   │       ├── main.tf
│   │       ├── modules
│   │       │   └── aws-instance
│   │       │       ├── main.tf
│   │       │       ├── outputs.tf
│   │       │       └── variables.tf
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       └── variables.tf
│   ├── data-source
│   │   ├── learn-terraform-data-sources-app
│   │   └── learn-terraform-data-sources-vpc
│   ├── lab01
│   │   └── main.tf
│   ├── lab02
│   │   └── ec2.tf
│   ├── one-server
│   │   └── main.tf
│   ├── one-web-server-with-vars
│   │   └── learn-terraform-variables
│   ├── one-webserver
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── webserver-cluster
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── 03
│   ├── README.md
│   ├── elb-web-db
│   │   ├── global
│   │   │   └── s3
│   │   │       ├── main.tf
│   │   │       └── output.tf
│   │   └── stage
│   │       ├── data-stores
│   │       │   └── mysql
│   │       │       ├── db_credentials.sh
│   │       │       ├── main.tf
│   │       │       ├── output.tf
│   │       │       └── variables.tf
│   │       └── services
│   │           └── webserver-cluster
│   │               ├── main.tf
│   │               ├── output.tf
│   │               └── user-data.sh
│   ├── global
│   │   ├── instance
│   │   │   └── main.tf
│   │   └── s3
│   │       ├── main.tf
│   │       └── output.tf
│   └── troubleshooting
│       └── learn-terraform-troubleshooting
│           ├── LICENSE
│           ├── README.md
│           ├── logs.txt
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
├── 04
│   ├── module-create
│   │   └── learn-terraform-modules-create
│   │       ├── LICENSE
│   │       ├── README.md
│   │       ├── main.tf
│   │       ├── modules
│   │       │   └── aws-s3-static-website-bucket
│   │       │       ├── LICENSE
│   │       │       ├── README.md
│   │       │       ├── main.tf
│   │       │       ├── outputs.tf
│   │       │       ├── variables.tf
│   │       │       └── www
│   │       │           ├── error.html
│   │       │           └── index.html
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       └── variables.tf
│   ├── module-overview
│   │   └── learn-terraform-modules-use
│   │       ├── LICENSE
│   │       ├── README.md
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── terraform.tf
│   │       └── variables.tf
│   └── vpc-create
│       ├── dev
│       │   ├── main.tf
│       │   ├── provider.tf
│       │   └── variables.tf
│       └── modules
│           ├── ec2
│           │   ├── main.tf
│           │   ├── outputs.tf
│           │   └── variables.tf
│           └── vpc
│               ├── main.tf
│               ├── outputs.tf
│               └── variables.tf
├── 05
│   ├── function
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── user_data.sh
│   │   └── variables.tf
│   └── loop-cond
│       ├── count
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       └── foreach
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
├── README.md
├── covertf
│   ├── README.md
│   ├── main.tf
│   ├── origin.yaml
│   └── output.tf
├── miniproject1
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── sshconfig.tpl
│   ├── userdata.tpl
│   └── variables.tf
├── miniproject2
│   ├── dev
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── modules
│       ├── alb
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       ├── asg
│       │   ├── main.tf
│       │   ├── userdata.sh
│       │   └── variables.tf
│       ├── db
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       └── vpc
│           ├── main.tf
│           └── outputs.tf
└── miniproject3
    ├── main.tf
    ├── modules
    │   ├── codebuild
    │   │   ├── buildspec.yaml
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── codepipeline
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   └── init
    │       ├── main.tf
    │       ├── outputs.tf
    │       └── variables.tf
    ├── provider.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── variables.tf

61 directories, 114 files
