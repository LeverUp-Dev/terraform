variable "identity_file" {
  description = "Location of private key file(public key file name will be given in 'privkey.pub')"
  type = string
  default = "~/.ssh/id_ed25519"
}