🌐 Task Flow — API Gateway (ClickOps)
🎯 Objective

Expose two Lambda functions through HTTP endpoints using API Gateway:

/python → Python Lambda

🧠 Concept Before Clicking (Say This First)

“Lambda does nothing until something calls it. API Gateway is how the outside world talks to your function.”

Mental model: Client → API Gateway → Lambda → Logs → Response

Key ideas:

  API Gateway = front door
  Lambda = execution engine
  Routes = decision logic

⚙️ Task 1 — Create API Gateway
📍 Navigation
AWS Console → API Gateway
Click: Create API

Choose👉 HTTP API (NOT REST API)

Why? Because it's....
    Cheaper
    Faster
    Less configuration
    Production-viable

Click: Build (HTTP API)

🔗 Task 2 — Add Integrations

You’ll connect Lambda functions.

➤ Integration 1 (Python)
Click Add integration
    Select: Lambda 
    Choose: chewbacca-python-lambda
    Sorry.... no Lizzo lambda... AWS Cloud isn't big enough for that.

➤ Integration 2 (Node.js)
Click Add integration
Select: Lambda
Choose: chewbacca-node-lambda


