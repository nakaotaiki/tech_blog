terraform {
  required_version = "1.1.9" //インストールしたバージョンに合わせる
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
  }

  backend "s3" {
    bucket = "commonsource"
    key    = "ap-northeast-1/tech_blog/terraform.tfstate"
    region = "ap-northeast-1"
  }
}