Problem: Multiple '/login' routes caused FastAPI to register one over the other, leading to inconsistent behavior. 
Fix: Removed the duplicate route and kept a single 'POST /login' implementation. Verified via Swagger and curl that authentication works consistently. 
Reproduction steps (original): 
1. Start app, open Swagger. 
2. Call 'POST /login'. 
3. Observe handler ambiguity when duplicate definitions exist. 
Status: Verified locally after change. 
