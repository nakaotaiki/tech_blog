// ドメイン設定
data "aws_route53_zone" "main" {
  name       = "${var.common.domain}.com."
  depends_on = [aws_route53_zone.main]
}

resource "aws_route53_zone" "main" {
  force_destroy = false
  name          = "${var.common.domain}.com"
}

resource "aws_route53_record" "main" {
  type       = "A"
  zone_id    = data.aws_route53_zone.main.id
  name       = var.common.sub_domain
  ttl        = "300"
  records    = [aws_lightsail_static_ip.main.ip_address]
  depends_on = [aws_route53_zone.main]
}

// SSHアクセスキーの設定
resource "aws_lightsail_key_pair" "main" {
  name       = "key_pair_${var.common.sub_domain}"
  public_key = file("./id_rsa.pub")
}

// 静的PublicIPアドレスの作成
resource "aws_lightsail_static_ip" "main" {
  name = "static_ip_${var.common.sub_domain}"
}

// wordpressサーバー構築
resource "aws_lightsail_instance" "main" {
  name              = var.common.sub_domain
  availability_zone = "ap-northeast-1a"
  blueprint_id      = "wordpress"
  bundle_id         = "micro_2_0"
  key_pair_name     = aws_lightsail_key_pair.main.name
}
// 静的PublicIPアドレスを設定
resource "aws_lightsail_static_ip_attachment" "main" {
  static_ip_name = aws_lightsail_static_ip.main.name
  instance_name  = aws_lightsail_instance.main.name
  depends_on     = [aws_lightsail_instance.main]
}
