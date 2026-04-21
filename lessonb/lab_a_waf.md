🛡️ WAF Lab — Protecting API Gateway (ClickOps)

“We are binding protection directly to the front door.”

🎯 Objective

Attach a Web Application Firewall (WAF) to your API so that:

Malicious or suspicious requests are blocked before Lambda
Students see real security controls in action
Logs + behavior reinforce “edge-first security”

🧠 Concept First (Say This Before Clicking)

“Right now your API trusts everyone. WAF is your first line of defense.”

🔁 Updated Request Flow: Client → WAF → API Gateway → Lambda → Logs
👉 Critical insight: If WAF blocks → API Gateway and Lambda are NEVER reached

🧱 What We’re Building
    WAF Web ACL
    Rules:
        Block obvious bad patterns
        Rate limiting (optional but powerful)
    Attach WAF to API Gateway

⚙️ Task 1 — Create Web ACL
📍 Navigation
AWS Console → WAF & Shield
Click Create Web ACL

🛠️ Configuration
Name: chewbacca-api-waf
Resource Type:: Regional resources
Region: 👉 Same region as your API Gateway
Associated Resource:
Select: API Gateway
Choose your API




