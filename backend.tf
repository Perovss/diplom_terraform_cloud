terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "perovss"

    workspaces {
      prefix = "stage-"
  }
}
}