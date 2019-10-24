data "aws_iam_policy_document" "soboon" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "soboon" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.soboon.json
}

resource "aws_iam_role_policy_attachment" "enhanced_health" {
  role       = aws_iam_role.soboon.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = aws_iam_role.soboon.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}