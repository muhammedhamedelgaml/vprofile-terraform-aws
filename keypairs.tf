resource "aws_key_pair" "vprokey" {
key_name = "vpro-key" // key we be created at aws with this name
public_key = file(var.PUB_KEY_PATH)   // pass pub key path variable
}