# Aegis Governance

**Project Aegis** - A multi-cloud governance engine for cost optimization and security compliance across AWS and Azure.

## Structure

- `.github/workflows/` - GitHub Actions for policy execution
- `policies/` - Cloud Custodian YAML policy files
- `scripts/` - Custom remediation logic

## Getting Started

1. Configure AWS OIDC Identity Provider
2. Configure Azure App Registration with Federated Credentials
3. Add required secrets to GitHub repository
4. Run the test connection workflow to verify setup

## Tools Used

- [Cloud Custodian](https://cloudcustodian.io/) - Policy as Code engine
- [Steampipe](https://steampipe.io/) - SQL-based cloud querying
- [Powerpipe](https://powerpipe.io/) - Compliance dashboards
