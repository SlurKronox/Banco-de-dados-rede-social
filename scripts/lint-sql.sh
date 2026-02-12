#!/usr/bin/env bash
set -euo pipefail

sqlfluff lint Schema.sql --dialect mysql --rules PRS
