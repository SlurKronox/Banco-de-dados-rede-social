# 🎯 MOVO - Rede Social

> **Conecte-se, Compartilhe, Movimente-se!**

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura do Banco de Dados](#arquitetura-do-banco-de-dados)
3. [Entidades Principais](#entidades-principais)
4. [Relacionamentos](#relacionamentos)
5. [Funcionalidades](#funcionalidades)
6. [Diferenciais do MOVO](#diferenciais-do-movo)
7. [Fluxos de Uso](#fluxos-de-uso)
8. [Queries Úteis](#queries-úteis)

---

## 🎨 Visão Geral

**MOVO** é uma rede social moderna focada em **movimento, conexão e compartilhamento de momentos**. A plataforma combina os melhores recursos de redes sociais tradicionais com inovações que incentivam interações genuínas.

### Pilares do MOVO
- 🌍 **Conectividade Global**: Conecte-se com pessoas do mundo todo
- 📸 **Momentos Visuais**: Compartilhe fotos e vídeos de forma intuitiva
- 💬 **Conversas Significativas**: Sistema de mensagens e comentários robusto
- 🎭 **Comunidades Temáticas**: Grupos e comunidades organizadas por interesse
- ⭐ **Engajamento Autêntico**: Sistema de reações e interações diversificado

---

## 🗄️ Arquitetura do Banco de Dados

### Estrutura Geral

```
MOVO Database
│
├── 👤 Módulo de Usuários
│   ├── USUARIO
│   ├── PERFIL_PRIVACIDADE
│   └── CONFIGURACAO_NOTIFICACAO
│
├── 📱 Módulo de Conteúdo
│   ├── POSTAGEM
│   ├── FOTO
│   ├── VIDEO
│   ├── ALBUM
│   ├── STORY
│   └── COMENTARIO
│
├── 🤝 Módulo Social
│   ├── AMIZADE
│   ├── SEGUIR
│   ├── BLOQUEIO
│   └── DENUNCIA
│
├── 👥 Módulo de Grupos
│   ├── GRUPO
│   ├── MEMBRO_GRUPO
│   └── POSTAGEM_GRUPO
│
├── 💌 Módulo de Comunicação
│   ├── MENSAGEM
│   ├── CONVERSA
│   └── PARTICIPANTE_CONVERSA
│
├── ⚡ Módulo de Interações
│   ├── CURTIDA
│   ├── REACAO
│   ├── COMPARTILHAMENTO
│   ├── SALVOS
│   └── TAG
│
└── 🔔 Módulo de Notificações
    ├── NOTIFICACAO
    └── CONFIGURACAO_NOTIFICACAO
```

---

## 📊 Entidades Principais

### 👤 USUARIO

Entidade central que representa cada pessoa na plataforma MOVO.

**Atributos:**
- `id_usuario` (PK)
- `nome_completo`
- `nome_usuario` (único, @username)
- `email` (único)
- `senha_hash`
- `data_nascimento`
- `sexo`
- `bio` (descrição do perfil)
- `foto_perfil_url`
- `foto_capa_url`
- `cidade`
- `pais`
- `telefone`
- `link_site_pessoal`
- `data_cadastro`
- `ultimo_acesso`
- `conta_verificada` ✓
- `conta_privada` 🔒
- `status_conta` (ativo/inativo/suspenso)
- `idioma_preferido`

**Características:**
- Username único com @ (ex: @maria_movo)
- Badge de verificação para contas autênticas
- Modo privado para controle de privacidade
- Suporte multilíngue

---

### 📱 POSTAGEM

Conteúdo principal compartilhado pelos usuários.

**Atributos:**
- `id_postagem` (PK)
- `id_usuario` (FK)
- `texto_conteudo`
- `tipo_postagem` (texto/foto/video/enquete/galeria)
- `data_publicacao`
- `localizacao`
- `privacidade` (publico/amigos/privado/personalizado)
- `permite_comentarios`
- `permite_compartilhamentos`
- `total_curtidas`
- `total_comentarios`
- `total_compartilhamentos`
- `total_visualizacoes`
- `em_destaque` (boolean)

**Tipos de Postagem:**
1. **Texto**: Pensamentos e atualizações
2. **Foto**: Imagens únicas ou galerias
3. **Vídeo**: Conteúdo audiovisual
4. **Enquete**: Pesquisas de opinião
5. **Galeria**: Múltiplas fotos em carrossel

---

### 🎭 STORY

Conteúdo efêmero que desaparece em 24 horas (estilo Instagram/WhatsApp).

**Atributos:**
- `id_story` (PK)
- `id_usuario` (FK)
- `tipo_midia` (foto/video)
- `url_midia`
- `texto_overlay`
- `cor_fundo`
- `data_publicacao`
- `data_expiracao` (automático: +24h)
- `visualizacoes`
- `permite_respostas`

**Funcionalidades Especiais:**
- Contador de visualizações
- Lista de quem viu
- Respostas diretas via mensagem
- Filtros e stickers

---

### 👥 GRUPO

Comunidades temáticas dentro do MOVO.

**Atributos:**
- `id_grupo` (PK)
- `id_criador` (FK)
- `nome_grupo`
- `descricao`
- `foto_grupo_url`
- `foto_capa_url`
- `categoria` (tecnologia/esportes/arte/etc)
- `data_criacao`
- `tipo_grupo` (publico/privado/secreto)
- `total_membros`
- `total_postagens`
- `regras_grupo` (TEXT)
- `tags` (palavras-chave)

**Tipos de Grupo:**
- 🌍 **Público**: Qualquer um pode ver e entrar
- 🔐 **Privado**: Visível, mas precisa aprovação
- 🕵️ **Secreto**: Invisível nas buscas, apenas por convite

---

### 💬 COMENTARIO

Sistema de comentários hierárquico com threads.

**Atributos:**
- `id_comentario` (PK)
- `id_postagem` (FK)
- `id_usuario` (FK)
- `id_comentario_pai` (FK - NULL para raiz)
- `texto_comentario`
- `data_comentario`
- `editado` (boolean)
- `data_edicao`
- `total_curtidas`
- `total_respostas`
- `nivel_thread` (profundidade: 0, 1, 2...)

**Recursos:**
- Threads infinitas (respostas a respostas)
- Edição de comentários (marcado)
- Menções com @
- Emojis e GIFs

---

### 💌 MENSAGEM / CONVERSA

Sistema de mensagens diretas do MOVO.

**CONVERSA:**
- `id_conversa` (PK)
- `tipo_conversa` (individual/grupo)
- `nome_conversa` (para grupos)
- `foto_conversa_url`
- `data_criacao`
- `ultima_atividade`

**MENSAGEM:**
- `id_mensagem` (PK)
- `id_conversa` (FK)
- `id_remetente` (FK)
- `texto_mensagem`
- `tipo_mensagem` (texto/foto/video/audio/arquivo)
- `url_anexo`
- `data_envio`
- `editada` (boolean)
- `deletada` (boolean)

**PARTICIPANTE_CONVERSA:**
- `id_conversa` (FK, PK)
- `id_usuario` (FK, PK)
- `data_entrada`
- `ultima_leitura`
- `silenciado` (boolean)
- `papel` (admin/membro)

---

## 🔗 Relacionamentos

### Relacionamentos N:M (Tabelas Intermediárias)

#### 1️⃣ AMIZADE
```
Usuario1 ←→ Usuario2
Status: pendente → aceito
```

#### 2️⃣ SEGUIR
```
Seguidor → Seguido
Unidirecional (não precisa ser recíproco)
```

#### 3️⃣ CURTIDA
```
Usuario + Postagem + Tipo de Reação
Reações: curtir ❤️, amar 😍, haha 😂, uau 😮, triste 😢, grr 😠
```

#### 4️⃣ MEMBRO_GRUPO
```
Usuario + Grupo + Papel
Papéis: membro, moderador, admin
```

#### 5️⃣ TAG_FOTO
```
Usuario + Foto + Posição (x, y)
Marcação de pessoas em fotos
```

#### 6️⃣ COMPARTILHAMENTO
```
Usuario + Postagem + Texto Adicional
Repost com comentário próprio
```

#### 7️⃣ SALVOS
```
Usuario + Postagem + Coleção
Organizar posts salvos em pastas
```

---

## ⚡ Funcionalidades

### 🎯 Funcionalidades Principais

#### 1. Feed Inteligente
- **Algoritmo baseado em relevância**
  - Posts de amigos
  - Conteúdo seguido
  - Posts populares de grupos
  - Sugestões personalizadas
- **Filtros de visualização**
  - Mais recentes
  - Mais relevantes
  - Apenas amigos
  - Por categoria

#### 2. Sistema de Stories
- Duração: 24 horas
- Visualizações rastreadas
- Respostas rápidas
- Compartilhamento de posts nos stories
- Destaques permanentes no perfil

#### 3. Mensagens MOVO
- Chat individual e em grupo
- Suporte a mídia (foto, vídeo, áudio)
- Chamadas de voz e vídeo (referência externa)
- Mensagens temporárias
- Reações rápidas
- Compartilhar postagens via mensagem

#### 4. Grupos & Comunidades
- Criar grupos por interesse
- Sistema de moderação
- Posts exclusivos do grupo
- Eventos do grupo
- Arquivos compartilhados
- Regras personalizadas

#### 5. Sistema de Privacidade
- Controle de quem vê suas postagens
- Conta privada
- Bloquear usuários
- Denunciar conteúdo
- Ocultar stories de usuários
- Lista de amigos próximos

#### 6. Interações Sociais
- Curtidas e reações
- Comentários com threads
- Compartilhamentos
- Salvamento de posts
- Marcações em fotos
- Menções (@usuario)
- Hashtags (#tema)

---

### 🌟 Diferenciais do MOVO

#### 1. **Sistema de Moedas MOVO** 🪙
- Ganhe "Moedas MOVO" por engajamento
- Use para destacar posts
- Envie presentes virtuais
- Desbloqueie temas personalizados

**Tabela: MOEDA_MOVO**
```sql
- id_transacao (PK)
- id_usuario (FK)
- tipo_transacao (ganho/gasto)
- quantidade
- descricao
- data_transacao
```

#### 2. **MOVO Live** 📹
- Transmissões ao vivo
- Chat em tempo real
- Reações durante a live
- Salvar replay por 48h

**Tabela: LIVE**
```sql
- id_live (PK)
- id_usuario (FK)
- titulo
- descricao
- data_inicio
- data_fim
- espectadores_pico
- total_visualizacoes
- url_replay
```

#### 3. **MOVO Eventos** 🎉
- Criar eventos
- RSVP (confirmar presença)
- Compartilhar com amigos
- Lembretes automáticos

**Tabela: EVENTO**
```sql
- id_evento (PK)
- id_criador (FK)
- nome_evento
- descricao
- data_hora_inicio
- data_hora_fim
- localizacao
- tipo_evento (presencial/online)
- url_evento
- total_confirmados
```

#### 4. **Sistema de Conquistas** 🏆
- Badges por atividades
- Conquistas especiais
- Ranking de usuários ativos

**Tabela: CONQUISTA**
```sql
- id_conquista (PK)
- nome_conquista
- descricao
- icone_url
- criterio
```

**Tabela: USUARIO_CONQUISTA**
```sql
- id_usuario (FK, PK)
- id_conquista (FK, PK)
- data_desbloqueio
- exibir_perfil (boolean)
```

---

## 🔄 Fluxos de Uso

### 1️⃣ Fluxo de Cadastro
```
1. Usuario preenche dados básicos
2. Valida email (código enviado)
3. Escolhe username único (@nome)
4. Adiciona foto de perfil (opcional)
5. Importa contatos (opcional)
6. Segue sugestões iniciais
7. Completa perfil
```

### 2️⃣ Fluxo de Postagem
```
1. Usuario clica em "Criar Post"
2. Escolhe tipo (texto/foto/video)
3. Adiciona conteúdo
4. Define localização (opcional)
5. Marca amigos (opcional)
6. Define privacidade
7. Publica
8. Notifica seguidores/amigos
```

### 3️⃣ Fluxo de Amizade
```
Usuario A                    Usuario B
    |                            |
    |---(1) Envia solicitação--->|
    |                            |
    |<--(2) Recebe notificação---|
    |                            |
    |---(3) Aceita pedido------->|
    |                            |
    |<---(4) Amizade confirmada--|
    |                            |
    └─────────Feed atualizado────┘
```

### 4️⃣ Fluxo de Grupo
```
1. Usuario cria grupo
2. Define tipo (público/privado/secreto)
3. Convida membros iniciais
4. Define regras e descrição
5. Membros postam conteúdo
6. Moderadores gerenciam
7. Grupo aparece em buscas (se público)
```

---

## 🔍 Queries Úteis

### 📌 1. Feed do Usuário (Posts de Amigos + Seguidos)

```sql
SELECT 
    p.*,
    u.nome_usuario,
    u.foto_perfil_url,
    COUNT(DISTINCT c.id_curtida) as total_curtidas_real,
    COUNT(DISTINCT co.id_comentario) as total_comentarios_real
FROM POSTAGEM p
INNER JOIN USUARIO u ON p.id_usuario = u.id_usuario
LEFT JOIN CURTIDA c ON p.id_postagem = c.id_postagem
LEFT JOIN COMENTARIO co ON p.id_postagem = co.id_postagem
WHERE p.id_usuario IN (
    -- Amigos
    SELECT id_usuario2 FROM AMIZADE 
    WHERE id_usuario1 = ? AND status_amizade = 'aceito'
    UNION
    SELECT id_usuario1 FROM AMIZADE 
    WHERE id_usuario2 = ? AND status_amizade = 'aceito'
    UNION
    -- Seguidos
    SELECT id_seguido FROM SEGUIR WHERE id_seguidor = ?
)
GROUP BY p.id_postagem
ORDER BY p.data_publicacao DESC
LIMIT 20;
```

### 📌 2. Stories Ativos (últimas 24h)

```sql
SELECT 
    s.*,
    u.nome_usuario,
    u.foto_perfil_url
FROM STORY s
INNER JOIN USUARIO u ON s.id_usuario = u.id_usuario
WHERE s.data_expiracao > NOW()
    AND s.id_usuario IN (
        SELECT id_seguido FROM SEGUIR WHERE id_seguidor = ?
        UNION
        SELECT ? -- próprio usuário
    )
ORDER BY s.data_publicacao DESC;
```

### 📌 3. Notificações Não Lidas

```sql
SELECT 
    n.*,
    u_origem.nome_usuario as quem_gerou,
    u_origem.foto_perfil_url
FROM NOTIFICACAO n
INNER JOIN USUARIO u_origem ON n.id_usuario_origem = u_origem.id_usuario
WHERE n.id_usuario_destino = ?
    AND n.lida = FALSE
ORDER BY n.data_notificacao DESC
LIMIT 50;
```

### 📌 4. Sugestões de Amizade (Amigos em Comum)

```sql
SELECT 
    u.id_usuario,
    u.nome_usuario,
    u.nome_completo,
    u.foto_perfil_url,
    COUNT(DISTINCT a2.id_usuario2) as amigos_em_comum
FROM USUARIO u
INNER JOIN AMIZADE a1 ON (u.id_usuario = a1.id_usuario1 OR u.id_usuario = a1.id_usuario2)
INNER JOIN AMIZADE a2 ON (
    (a2.id_usuario1 = ? OR a2.id_usuario2 = ?)
    AND a2.status_amizade = 'aceito'
)
WHERE u.id_usuario != ?
    AND u.id_usuario NOT IN (
        SELECT id_usuario2 FROM AMIZADE WHERE id_usuario1 = ?
        UNION
        SELECT id_usuario1 FROM AMIZADE WHERE id_usuario2 = ?
    )
GROUP BY u.id_usuario
HAVING amigos_em_comum > 0
ORDER BY amigos_em_comum DESC
LIMIT 10;
```

### 📌 5. Posts Mais Populares do Dia

```sql
SELECT 
    p.*,
    u.nome_usuario,
    u.foto_perfil_url,
    (p.total_curtidas * 2 + p.total_comentarios * 3 + p.total_compartilhamentos * 5) as score_engajamento
FROM POSTAGEM p
INNER JOIN USUARIO u ON p.id_usuario = u.id_usuario
WHERE p.data_publicacao >= CURDATE()
    AND p.privacidade = 'publico'
ORDER BY score_engajamento DESC
LIMIT 20;
```

### 📌 6. Mensagens Não Lidas por Conversa

```sql
SELECT 
    c.id_conversa,
    c.nome_conversa,
    c.foto_conversa_url,
    COUNT(m.id_mensagem) as mensagens_nao_lidas,
    MAX(m.data_envio) as ultima_mensagem
FROM CONVERSA c
INNER JOIN PARTICIPANTE_CONVERSA pc ON c.id_conversa = pc.id_conversa
LEFT JOIN MENSAGEM m ON c.id_conversa = m.id_conversa
WHERE pc.id_usuario = ?
    AND m.data_envio > pc.ultima_leitura
    AND m.id_remetente != ?
GROUP BY c.id_conversa
ORDER BY ultima_mensagem DESC;
```

---

## 📈 Estatísticas e Análises

### Métricas de Usuário

**Tabela: ESTATISTICA_USUARIO**
```sql
- id_usuario (FK, PK)
- total_posts
- total_seguidores
- total_seguindo
- total_amigos
- total_grupos
- postagens_hoje
- engajamento_medio
- data_atualizacao
```

### Métricas de Conteúdo

**Tabela: ESTATISTICA_POSTAGEM**
```sql
- id_postagem (FK, PK)
- alcance (visualizações únicas)
- impressoes (visualizações totais)
- taxa_engajamento
- hora_pico_interacao
- demografia_visualizadores (JSON)
```

---

## 🔒 Segurança e Privacidade

### 1. Controles de Privacidade

**Tabela: PERFIL_PRIVACIDADE**
```sql
- id_usuario (FK, PK)
- perfil_publico (boolean)
- mostrar_email (boolean)
- mostrar_telefone (boolean)
- mostrar_aniversario (boolean)
- mostrar_localizacao (boolean)
- quem_pode_enviar_mensagem (todos/amigos/ninguem)
- quem_pode_marcar_fotos (todos/amigos/ninguem)
- quem_pode_comentar (todos/amigos/ninguem)
```

### 2. Sistema de Bloqueio

**Tabela: BLOQUEIO**
```sql
- id_usuario_bloqueador (FK, PK)
- id_usuario_bloqueado (FK, PK)
- data_bloqueio
- motivo
```

**Efeitos:**
- Não aparecem nos feeds um do outro
- Não podem enviar mensagens
- Não podem ver perfis
- Remove amizade/seguir automaticamente

### 3. Sistema de Denúncia

**Tabela: DENUNCIA**
```sql
- id_denuncia (PK)
- id_denunciante (FK)
- tipo_conteudo (postagem/comentario/usuario/mensagem)
- id_conteudo (referência)
- motivo (spam/ofensivo/fake/assedio/outro)
- descricao
- data_denuncia
- status (pendente/analisando/resolvido/rejeitado)
- id_moderador (FK, NULL)
- resolucao
- data_resolucao
```

---

## 🎨 Interface e UX

### Telas Principais

1. **Feed Inicial**
   - Stories no topo
   - Posts do feed
   - Sugestões de seguir
   - Anúncios (futuramente)

2. **Perfil**
   - Foto de perfil + capa
   - Bio e informações
   - Grid de posts
   - Destaques de stories
   - Conquistas

3. **Explorar**
   - Trending posts
   - Trending hashtags
   - Grupos sugeridos
   - Usuários sugeridos

4. **Notificações**
   - Curtidas
   - Comentários
   - Seguidores novos
   - Solicitações de amizade
   - Menções

5. **Mensagens**
   - Lista de conversas
   - Filtro: não lidas
   - Busca de conversas
   - Criar nova conversa

---

## 🚀 Roadmap Futuro

### Fase 1 (MVP) ✅
- [x] Cadastro e autenticação
- [x] Perfis de usuário
- [x] Posts (texto/foto/video)
- [x] Curtidas e comentários
- [x] Sistema de amizade
- [x] Feed básico

### Fase 2 (Atual) 🔄
- [ ] Stories
- [ ] Mensagens diretas
- [ ] Grupos
- [ ] Notificações em tempo real
- [ ] Sistema de privacidade avançado

### Fase 3 (Próximo) 📅
- [ ] MOVO Live
- [ ] Eventos
- [ ] Moedas MOVO
- [ ] Sistema de conquistas
- [ ] Marketplace

### Fase 4 (Futuro) 🔮
- [ ] MOVO Premium
- [ ] API pública
- [ ] Integração com outras redes
- [ ] MOVO Business (perfis comerciais)
- [ ] Analytics avançado

---

## 📞 Suporte

Para dúvidas sobre a modelagem ou implementação:
- 📧 Email: dev@movo.com
- 📚 Docs: docs.movo.com
- 💬 Discord: discord.gg/movo
- 🐛 Issues: github.com/movo/issues

---

## 📄 Licença

Este projeto é de propriedade da MOVO Inc.
Todos os direitos reservados © 2025

---

**Desenvolvido com ❤️ pela equipe MOVO**

*"Conecte-se, Compartilhe, Movimente-se!"*
