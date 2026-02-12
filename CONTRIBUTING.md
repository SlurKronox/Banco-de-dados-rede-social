# Contributing Guide

## Branch and Commits
- Default branch: `main`
- Open a pull request for every change
- Use clear commit messages (example: `feat: add index for feed query`)

## Development Checklist
1. Keep SQL changes minimal and reversible.
2. Run lint and schema build locally.
3. Run smoke tests.
4. Update documentation when behavior changes.

## Local Validation
```bash
python -m sqlfluff lint Schema.sql --dialect mysql
bash scripts/build-schema.sh
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < tests/smoke.sql
```

## Pull Request Requirements
- CI green (`lint`, `build`, `test`, `security`)
- No sensitive data in commits
- Clear migration rationale in PR description

## Code of Care
- Prefer explicit constraints over implicit behavior
- Document breaking schema changes in README and docs
