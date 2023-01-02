// 静的PublicIPアドレスを出力
output "static_ip" { value = aws_lightsail_static_ip.main.ip_address }