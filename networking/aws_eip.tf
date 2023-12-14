resource "aws_eip" "nleip1" {
  vpc = true
  depends_on = [aws_internet_gateway.jwgw]
}

resource "aws_eip" "nleip2" {
  vpc = true
  depends_on = [aws_internet_gateway.jwgw]
}