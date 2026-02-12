# CI

## Pipeline
Workflow: `.github/workflows/ci.yml`

Jobs:
- `lint`: valida parsing SQL
- `build`: recria banco MySQL e aplica schema
- `test`: reaplica schema e executa smoke tests

## Ambiente
- Runner: `ubuntu-latest`
- Serviço: `mysql:8.0`
- Cliente: `mysql-client`

## Critério de aprovação
PR só é considerado saudável com os três jobs verdes.

## English Summary
CI enforces SQL linting, clean schema deployment, and smoke tests on MySQL 8.
