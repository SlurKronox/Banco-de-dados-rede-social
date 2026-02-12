# Security Policy

## Supported Versions
Security updates are applied to the `main` branch.

| Version | Supported |
| --- | --- |
| main | Yes |
| other branches | No |

## Reporting a Vulnerability
Use GitHub Security Advisories ("Report a vulnerability") whenever possible.
If that is not available, open an issue with title prefix `[SECURITY]` and avoid publishing exploit details.

Please include:
- Impact and affected objects
- Reproduction steps
- Suggested mitigation

## Response Targets
- First triage response: up to 72 hours
- Mitigation plan: up to 7 business days
- Public disclosure: after patch or mitigation is available

## Scope
This policy covers SQL schema assets, CI workflows, and repository metadata.

## Operational Rules
- Never commit secrets or credentials
- Keep principle of least privilege in DB grants
- Validate schema changes through CI before merge
