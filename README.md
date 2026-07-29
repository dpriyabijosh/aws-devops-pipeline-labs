# DevOps Migration Project: Log Parser & AWS Landing Zone

A central repository demonstrating enterprise-grade DevOps engineering capabilities, featuring an automated Linux log parsing utility and a secured AWS cloud landing environment.

## 🛠️ Part 1: Linux Log Parser Script
This project includes a bash script (`log_parser.sh`) designed to scan system logs, extract error timestamps, and generate incident reports.

### Features
* Case-insensitive matching for "ERROR" logs using `grep`.
* Structured field extraction utilizing `awk`.
* Automated metric aggregation via `wc`.

### Usage
```bash
./log_parser.sh /path/to/your/logfile.log
```

---

## ☁️ Part 2: AWS Security & Identity Architecture

To support this project and all future automated deployments, a secure AWS sandbox environment was established following modern enterprise cloud security and cost optimization standards.

### Security Layout
```mermaid
graph TD
    subgraph Local M4 Mac Workspace
        Terminal[Mac Terminal] -->|1. Invokes Profile| CLIProfile[Named CLI Profile: sandbox-admin]
        CLIProfile -->|2. Reads Local Config| SecretStore[~/.aws/credentials File]
        SecretStore -->|3. Secured Via| FileLock[chmod 600 Permission Mask]
    end

    subgraph AWS Cloud Account (UK Region: eu-west-2)
        CLIProfile -->|4. Authenticates API Calls| IAMAdmin[Dedicated IAM Admin User]
        IAMAdmin -->|5. Manages Tasks| AWSResources[AWS Cloud Infrastructure]
        
        subgraph CostControls[Cost Controls]
            Budget[AWS Budgets] -->|6. Monitors Spending| Threshold{Exceeds \$5.00 daily?}
            Threshold -->|Yes| Email[Automated Personal Email Alert]
        end
    end
```

### Security & Governance Guardrails Implemented

* **Programmatic Environment Isolation:** Configured an isolated, named local CLI profile (`sandbox-admin`). This completely replaces the use of high-risk root credentials for daily task automation, ensuring the master root email account remains isolated from all terminal operations.
* **Local Credential Hardening:** Applied an explicit `chmod 600` file system access mask to the local `~/.aws/credentials` directory. This restricts host-level visibility so that only the authenticated macOS user can read the static API tokens, safeguarding the workspace from background process leaks.
* **Financial Governance & Cost Optimization:** Formed a strict **$5.00 daily threshold budget** with automated email alerting triggers. Activating a global multi-account AWS Organization structure was intentionally avoided to protect and maintain active Free Tier credits while operating within the local UK region (`eu-west-2`).
