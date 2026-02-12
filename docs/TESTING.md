# Testing

## Estratégia
Testes de banco são executados em duas camadas:
- Lint de parsing SQL (`sqlfluff`)
- Smoke test estrutural (`tests/smoke.sql`)

## Cobertura do smoke test
- Tabelas críticas criadas
- Triggers críticas registradas
- Views essenciais registradas
- Evento de manutenção registrado

## Execução local
```bash
bash scripts/build-schema.sh
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < tests/smoke.sql
```

## English Summary
Tests validate SQL parsing and core schema objects existence after clean database build.
