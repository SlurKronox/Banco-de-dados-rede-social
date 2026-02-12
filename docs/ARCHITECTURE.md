# Arquitetura

## Visão geral
O schema define uma base MySQL 8 para uma rede social completa, dividida em domínios funcionais.

## Domínios principais
- Usuários e privacidade
- Conteúdo (postagens, fotos, vídeos, stories)
- Relações sociais (amizade, seguir, bloqueio)
- Comunicação (conversas e mensagens)
- Interações (curtidas, comentários, compartilhamentos)
- Notificações e gamificação

## Artefatos técnicos
- `Schema.sql`: fonte única da modelagem
- Triggers para contadores e notificações automáticas
- Views para feed e ranking de engajamento
- Evento SQL para limpeza de stories expirados

## English Summary
MySQL schema organized by social-network domains with triggers, views, and event-based automation.
