terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "perovss"

    workspaces {name = "stage"}
  }
}
