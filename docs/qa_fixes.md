qa3-email-lookup-casefold-docs
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

# QA Fixes

## QA 1 — Docker image fails to build
**Problem**
- `docker build` failed due to an outdated base image and missing system dependencies.

**Reproduction**
1. From project root: `docker build -t myapp .`
2. Build fails with missing/incompatible deps.

**Fix**
- Switched to a compatible base image.
- Added required system packages.
- Verified local build: `docker build -t myapp .` completes successfully.

**Status**
- Verified locally after change.
- Tracked in issue: #1

---

## QA 2 — Duplicate `/login` route
**Problem**
- Two `/login` endpoints existed, letting FastAPI register one over the other and causing inconsistent behavior.

**Reproduction**
1. Start app and open Swagger UI.
2. Call `POST /login` and note handler ambiguity.

**Fix**
- Removed the duplicate route and consolidated auth into a single `/login` endpoint.

**Status**
- Verified via Swagger UI and curl.
- Tracked in issue: #2
main
