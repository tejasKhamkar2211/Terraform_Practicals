variable "my_region" {
    type = string
    default = "ap-south-1"
}

variable "my_ami" {
    type = string
    default =   "ami-0d682f26195e9ec0f"
}

variable "my_inst_type" {
    type = map
    default =  {
        default = "t2.micro"
        dev = "t2.nano"
        prod = "t2.small"
        test = "t2.medium"
    }
}

