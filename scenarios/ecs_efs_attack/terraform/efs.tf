resource "aws_efs_file_system" "admin-backup" {
  tags = {
    Name      = "cg-admin-backup-${var.cgid}"
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "5ed71abc-f70b-4767-b789-83f6fad5bc77"
    Owner     = "RGA"
  }
}


resource "aws_efs_mount_target" "alpha" {
  file_system_id  = "${aws_efs_file_system.admin-backup.id}"
  subnet_id       = "${aws_subnet.cg-public-subnet-1.id}"
  security_groups = ["${aws_security_group.cg-ec2-efs-security-group.id}"]
}

# EFS access point used by lambda file system
resource "aws_efs_access_point" "admin_access_point" {
  file_system_id = "${aws_efs_file_system.admin-backup.id}"

  root_directory {
    path = "/admin"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "777"
    }
  }

  posix_user {
    gid = 1000
    uid = 1000
  }
  tags = {
    git_org   = "RadoGar"
    git_repo  = "cloudgoat"
    yor_trace = "8a45c340-5559-4fdd-8df8-4a19a784cc5e"
    Owner     = "RGA"
  }
}
