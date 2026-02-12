# Banco de Dados MOVO (MySQL 8)

![CI](https://github.com/SlurKronox/Banco-de-dados-rede-social/actions/workflows/ci.yml/badge.svg)
![Security](https://github.com/SlurKronox/Banco-de-dados-rede-social/actions/workflows/security.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

Schema relacional da plataforma MOVO com foco em modelagem de usuarios, conteudo, interacoes sociais, comunicacao e notificacoes.

## Objetivo
Este repositorio centraliza o schema SQL oficial do projeto para MySQL 8.
A modelagem cobre entidades de rede social moderna com constraints, indices, triggers, views e evento de expiracao de stories.
O foco e manter evolucao controlada do banco com validacao automatica de qualidade e seguranca.

## Stack
- MySQL 8
- SQL (DDL, DML, triggers, views, event scheduler)
- SQLFluff (parse lint)
- GitHub Actions (CI e security checks)

## Arquitetura
- `Schema.sql`: definicao principal do banco
- `tests/smoke.sql`: validacoes de integridade estrutural
- `scripts/lint-sql.sh`: lint SQL
- `scripts/build-schema.sh`: recriacao de banco limpo e aplicacao do schema
- `docs/`: documentacao tecnica de apoio

## Setup Local
```bash
git clone https://github.com/SlurKronox/Banco-de-dados-rede-social.git
cd Banco-de-dados-rede-social
```

Variaveis opcionais:
```bash
export MYSQL_HOST=127.0.0.1
export MYSQL_PORT=3306
export MYSQL_USER=root
export MYSQL_PASSWORD=root
export MYSQL_DATABASE=movo
```

## Comandos
```bash
bash scripts/lint-sql.sh
bash scripts/build-schema.sh
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" < tests/smoke.sql
```

## Documentacao
- `docs/README.md`
- `docs/ARCHITECTURE.md`
- `docs/TESTING.md`
- `docs/CI.md`
- `docs/SECURITY.md`

## Governanca
- Politica de seguranca: `SECURITY.md`
- Guia de contribuicao: `CONTRIBUTING.md`

## English Summary
This repository contains the official MySQL 8 schema for the MOVO platform.
It is documented and protected with CI, smoke tests, and security governance documents.
