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
