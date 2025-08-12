Problem: Multiple '/login' routes caused FastAPI to register one over the other, leading to inconsistent behavior. 
Fix: Removed the duplicate route and kept a single 'POST /login' implementation. Verified via Swagger and curl that authentication works consistently. 
Reproduction steps (original): 
1. Start app, open Swagger. 
2. Call 'POST /login'. 
3. Observe handler ambiguity when duplicate definitions exist. 
Status: Verified locally after change. 
Problem: - 'get_by_email()' depended on '_fetch_user()' which compared emails with exact case. - Users registered as 'User@Example.com' couldn't log in with 'user@example.com'.
Reproduction: 
1. Register with 'User@Example.com'.
2. Try logging in with 'user@example.com'.
Login fails because user isn't found. 
Fix: 
- Normalize emails to lowercase before lookups (and during creation).
- Updated '_fetch_user()'/'get_by_email()' to compare lower-cased values. 
Status: 
- Verfied by registering with mixed-case email and logging in using different case formats. 
- Tracked in issue: #3
