# Security Baseline

## Objectives
- Protect schema integrity
- Prevent privilege escalation in SQL assets
- Reduce secret exposure risk in repository and CI

## Controls
- CI validates schema parsing and smoke tests before merge
- Security workflow runs dependency review and secret scanning
- SQL changes are reviewed through pull requests

## Database Practices
- Prefer least-privilege DB users in runtime environments
- Avoid dynamic SQL without strict validation
- Keep foreign keys and constraints explicit
- Version changes through tracked SQL files only

## Secret Management
- Do not store credentials in SQL files or docs
- Use environment variables for CI and local execution
- Rotate DB credentials when exposure is suspected

## Incident Handling
1. Revoke exposed credentials immediately.
2. Open a security advisory and classify severity.
3. Patch and validate with CI.
4. Document mitigation in release notes.

## English Summary
This document defines repository-level security controls and incident response for SQL assets.
