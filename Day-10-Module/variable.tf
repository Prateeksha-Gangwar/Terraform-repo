variable "ami_id" {
    description = "The AMI ID to use for the instance"
    default = "" # Replace with a valid AMI ID for your region
}
variable "instance_type" {
    default = ""
}
variable "instance_name" {
    default = ""
}
