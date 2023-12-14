resource "aws_internet_gateway" "jwgw" {
  vpc_id = aws_vpc.nlvpc.id
}