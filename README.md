# Banco de Dados MOVO (MySQL 8)

![CI](https://github.com/SlurKronox/Banco-de-dados-rede-social/actions/workflows/ci.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

Schema relacional de uma rede social (MOVO) com foco em modelagem completa de usuários, conteúdo, interações sociais, comunicação e notificações.

## Objetivo
Este repositório centraliza o schema SQL do projeto MOVO para ambiente MySQL 8.
A modelagem cobre entidades de rede social moderna com constraints, índices, triggers, views e evento de expiração de stories.
O objetivo é permitir evolução controlada do banco com validações automatizadas em CI.

## Stack
- MySQL 8
- SQL (DDL, DML, triggers, views, event scheduler)
- SQLFluff (lint de parsing)
- GitHub Actions

## Arquitetura
- `Schema.sql`: definição principal do banco
- `tests/smoke.sql`: validações de integridade estrutural
- `scripts/lint-sql.sh`: lint SQL (parse)
- `scripts/build-schema.sh`: recriação de banco limpo + aplicação de schema
- `docs/`: documentação técnica de apoio

## Setup Local
```bash
git clone https://github.com/SlurKronox/Banco-de-dados-rede-social.git
cd Banco-de-dados-rede-social
```

Defina variáveis (opcional):
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

## Documentação
- `docs/ARCHITECTURE.md`
- `docs/TESTING.md`
- `docs/CI.md`

## English Summary
This repository contains the primary MySQL 8 schema for the MOVO social platform.
It includes structural validation through SQL smoke tests and CI jobs for lint, build, and test.