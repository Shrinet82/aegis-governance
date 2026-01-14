dashboard "aegis_overview" {
  title = "Aegis: The Autonomous Cloud Immune System"
  refresh = 5

  text {
    value = "Real-time cost optimization and security enforcement for AWS & Azure."
  }

  container {
    card {
      sql = <<-EOQ
        select
          count(*) as "Zombies Marked"
        from
          aws_ebs_volume
        where
          tags->>'custodian_status' is not null;
      EOQ
      width = 3
    }

    card {
      sql = <<-EOQ
        select
          sum(size) * 0.08 as "Est. Monthly Savings ($)"
        from
          aws_ebs_volume
        where
          tags->>'custodian_status' is not null;
      EOQ
      width = 3
    }
    
    card {
      type = "info"
      label = "Security Posture"
      value = "Active Enforcer"
      width = 3
    }

    card {
      type = "info"
      label = "MTTR"
      value = "< 60 seconds"
      width = 3
    }

    card {
      sql = <<-EOQ
        select
          count(*) as "Insecure S3 Buckets"
        from
          aws_s3_bucket
        where
          block_public_acls = false or block_public_policy = false;
      EOQ
      width = 3
      type = "alert"
    }

    card {
      sql = <<-EOQ
        select
          count(*) as "Insecure Storage Accounts"
        from
          azure_storage_account
        where
          enable_https_traffic_only = false;
      EOQ
      width = 3
      type = "alert"
    }

    card {
      sql = <<-EOQ
        select
          count(*) as "Insecure SG Rules"
        from
          aws_vpc_security_group_rule
        where
          is_egress = false
          and cidr_ipv4 = '0.0.0.0/0'
          and (from_port = 22 or from_port = 3389);
      EOQ
      width = 3
      type = "alert"
    }
  }

  table {
    title = "Orphaned Resources (Death Row)"
    sql = <<-EOQ
      select
        volume_id as "Volume ID",
        size as "Size (GB)",
        create_time as "Created",
        tags->>'custodian_status' as "Status"
      from
        aws_ebs_volume
      where
        tags->>'custodian_status' is not null
      order by
        create_time desc;
    EOQ
  }

  table {
    title = "Pending Kills (Grace Period - 5m)"
    sql = <<-EOQ
      select
        group_id as "Security Group ID",
        group_name as "Name",
        tags->>'custodian_cleanup' as "Deadline",
        'Insecure Ingress (SSH/RDP)' as "Violation"
      from
        aws_vpc_security_group
      where
        tags->>'custodian_cleanup' is not null;
    EOQ
  }

  table {
    title = "Recent Kills (Real-time Log)"
    sql = <<-EOQ
      select
        timestamp as "Time",
        'Revoke Security Group Rules' as "Action",
        'Neutralized' as "Status",
        message as "Log Message"
      from
        aws_cloudwatch_log_event
      where
        log_group_name = '/aws/lambda/custodian-aws-sg-remediate-marked'
        and message like '%invoking action:remove-permissions%'
      order by
        timestamp desc
      limit 10;
    EOQ
  }
}
