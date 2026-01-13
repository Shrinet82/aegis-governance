# 🛡️ Project Aegis: The Autonomous Cloud Immune System

> _"A governance engine that cleans up cost leakage and neutralizes security threats in <60 seconds."_

**Project Aegis** is a multi-cloud governance platform (AWS & Azure) built with **Policy-as-Code**. Unlike traditional "audit" tools that just send emails, Aegis acts as an active immune system—automatically identifying orphaned resources ("zombies") and destroying security risks instantly.

## 🚀 Key Capabilities

| Protocol        | Function                                 | MTTR (Mean Time to Remediate) | Value                   |
| --------------- | ---------------------------------------- | ----------------------------- | ----------------------- |
| **Janitor** 🧹  | Identifies & deletes orphaned EBS/Disks  | 4 Days (Retention Policy)     | **Cost Optimization**   |
| **Enforcer** 🔫 | Detects & kills insecure Security Groups | **< 30 Seconds**              | **Zero-Trust Security** |
| **Auditor** 📊  | Visualizes compliance & savings          | Real-time                     | **Observability**       |

## 🏗️ Architecture

- **Control Plane**: GitHub Actions (OIDC Federation - No static keys!)
- **Engine**: Cloud Custodian (c7n)
- **Triggers**: CloudTrail (AWS) & Event Grid (Azure)
- **Dashboard**: Steampipe + Powerpipe

## 🛠️ How It Works

### 1. Cost Governance (The Janitor)

Runs daily to mark unattached resources.

- **Mark**: Tags orphaned EBS/IPs with `custodian_status: delete@YYYY-MM-DD`.
- **Sweep**: Deletes resources that pass the retention period.
- _Verified_: Saved estimated **$140/mo** in unused storage during testing.

### 2. Security Enforcement (The Enforcer)

Event-driven Lambda functions that listen for dangerous API calls.

- **Scenario**: User creates a Security Group Rule allowing `0.0.0.0/0` on port 22.
- **Reaction**: CloudTrail -> EventBridge -> Lambda -> **Rule Revoked**.
- _Verified_: Attack neutralized in **18 seconds**.

## 📊 Compliance Dashboard

Dashboard built with Powerpipe to track realized savings and compliance score.

![Dashboard Placeholder](dashboard-screenshot.png)

## 🔧 Deployment

1. **Clone & Config**:

   ```bash
   git clone https://github.com/Shrinet82/aegis-governance.git
   # Configure AWS/Azure OIDC connections (see wiki)
   ```

2. **Deploy Enforcers**:
   Push to `main` updates the `deploy-enforcers` workflow, provisioning Lambdas automatically.

---

_Part of the 2026 Autonomous Cloud Stack._
