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
Problem: Newly registered users receive a verification link like 'http://localhost:8000/verify-email/None/', so verification fails. 
Reproductions: 
1. Register via 'POST /register'.
2. Open Mailtrap and copy the verification link. 
3. Link path contains 'None' instead of the user UUID. 
Root causes: 
'new_user.id' not populated when composing the email-email sent right after 'commit()' without refreshing the instance. 
Fix: 
Refresh the user after commit and before composing/sending the email:
```python
await db_session.commit()
await db_session.refresh(new_user)          # <-- ensures new_user.id is set
await email_service.send_verification_email(new_user)

Verification: 
Registered a new user; the email now contains the correct UUID and hitting /verify-email/<uuid> returns 200 (Email verified successfully"). 
Problem:
`login_user` returned `None` for failures (bad password, unverified email, locked account), giving the API no reason to report and resulting in poor UX.
Reproduction
1. Try login with wrong password.
2. Try login with unverified email.
3. Try login with a locked account.
All cases return `None` without context.
Fix: 
Replace silent `return None` branches with explicit exceptions carrying clear messages, e.g.:
```python
if not verify_password(password, user.hashed_password):
    raise ValueError("Incorrect email or password")
if not user.email_verified:
    raise ValueError("Email not verified")
if user.is_locked:
    raise ValueError("Account is locked")

Verification:
git add docs/qa_fixes.md
Verification:
Tested all the three scenarios in Swagger: responses now return accurate codes and messages 
