Lab 6 – Compliance & Security Event Monitor (“Mini-SIEM Lite”)

Problem to solve
Build a lightweight serverless “compliance monitor” that reacts to security-related events and logs them into Aurora with alerting.

Core services

    EventBridge (rules for CloudTrail, Security Hub, GuardDuty, or synthetic security events)
    Lambda (normalization + rules engine)
    Aurora (security_events, incidents tables)
    SNS (security-alert topic)
    SQS (for buffering high-volume events)

Criteria for success

    At least 3 event patterns (e.g., ConsoleLogin, RootUserAction, SecurityFindingDetected) routed via EventBridge.
    Lambda normalizes all of them into a single Aurora schema (e.g., security_events with type, account, timestamp, details).
    Additional “severity rules” Lambda:
        reads new events from Aurora or SQS
        upgrades some to “incidents” and publishes to SNS.
    Demo includes:
        sending a synthetic dangerous event and showing it appear as a row in Aurora AND trigger an SNS alert.
    IaC fully managed via Terraform.
