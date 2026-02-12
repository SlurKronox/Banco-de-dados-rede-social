# CI

## Workflows
- `.github/workflows/ci.yml`
- `.github/workflows/security.yml`

## CI Jobs
- `lint`: valida parsing SQL
- `build`: recria banco MySQL e aplica schema
- `test`: reaplica schema e executa smoke tests

## Security Jobs
- `dependency-review`: revisa alteracoes de dependencias em PR
- `secret-scan`: executa varredura de segredos com Gitleaks

## Ambiente
- Runner: `ubuntu-latest`
- Servico: `mysql:8.0`
- Cliente: `mysql-client`

## Criterio de aprovacao
PR e considerado saudavel apenas com CI e Security verdes.

## English Summary
CI enforces SQL linting, schema deployment, and smoke tests; Security workflow adds dependency and secret scanning.
