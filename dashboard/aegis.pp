dashboard "aegis_overview" {
  title = "Aegis: The Autonomous Cloud Immune System"

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
}
