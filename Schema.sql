-- ============================================
-- MOVO - REDE SOCIAL
-- Schema SQL Completo
-- "Conecte-se, Compartilhe, Movimente-se!"
-- ============================================

-- ==========================================
-- MÓDULO DE USUÁRIOS
-- ==========================================

-- Tabela: USUARIO
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    nome_usuario VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_nascimento DATE,
    sexo ENUM('M', 'F', 'Outro', 'Prefiro não informar'),
    bio TEXT,
    foto_perfil_url VARCHAR(255),
    foto_capa_url VARCHAR(255),
    cidade VARCHAR(100),
    pais VARCHAR(50),
    telefone VARCHAR(20),
    link_site_pessoal VARCHAR(255),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acesso TIMESTAMP,
    conta_verificada BOOLEAN DEFAULT FALSE,
    conta_privada BOOLEAN DEFAULT FALSE,
    status_conta ENUM('ativo', 'inativo', 'suspenso') DEFAULT 'ativo',
    idioma_preferido VARCHAR(10) DEFAULT 'pt-BR',
    tema_interface ENUM('claro', 'escuro', 'auto') DEFAULT 'auto',
    INDEX idx_nome_usuario (nome_usuario),
    INDEX idx_email (email)
);

-- Tabela: PERFIL_PRIVACIDADE
CREATE TABLE PERFIL_PRIVACIDADE (
    id_usuario INT PRIMARY KEY,
    perfil_publico BOOLEAN DEFAULT TRUE,
    mostrar_email BOOLEAN DEFAULT FALSE,
    mostrar_telefone BOOLEAN DEFAULT FALSE,
    mostrar_aniversario BOOLEAN DEFAULT TRUE,
    mostrar_localizacao BOOLEAN DEFAULT TRUE,
    quem_pode_enviar_mensagem ENUM('todos', 'amigos', 'ninguem') DEFAULT 'todos',
    quem_pode_marcar_fotos ENUM('todos', 'amigos', 'ninguem') DEFAULT 'amigos',
    quem_pode_comentar ENUM('todos', 'amigos', 'ninguem') DEFAULT 'todos',
    quem_pode_ver_stories ENUM('todos', 'amigos', 'personalizado') DEFAULT 'todos',
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- Tabela: CONFIGURACAO_NOTIFICACAO
CREATE TABLE CONFIGURACAO_NOTIFICACAO (
    id_usuario INT PRIMARY KEY,
    notif_curtidas BOOLEAN DEFAULT TRUE,
    notif_comentarios BOOLEAN DEFAULT TRUE,
    notif_novos_seguidores BOOLEAN DEFAULT TRUE,
    notif_mencoes BOOLEAN DEFAULT TRUE,
    notif_solicitacao_amizade BOOLEAN DEFAULT TRUE,
    notif_mensagens BOOLEAN DEFAULT TRUE,
    notif_grupos BOOLEAN DEFAULT TRUE,
    notif_email BOOLEAN DEFAULT TRUE,
    notif_push BOOLEAN DEFAULT TRUE,
    notif_sms BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- Tabela: ESTATISTICA_USUARIO
CREATE TABLE ESTATISTICA_USUARIO (
    id_usuario INT PRIMARY KEY,
    total_posts INT DEFAULT 0,
    total_seguidores INT DEFAULT 0,
    total_seguindo INT DEFAULT 0,
    total_amigos INT DEFAULT 0,
    total_grupos INT DEFAULT 0,
    postagens_hoje INT DEFAULT 0,
    engajamento_medio DECIMAL(5,2) DEFAULT 0.00,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO DE CONTEÚDO
-- ==========================================

-- Tabela: POSTAGEM
CREATE TABLE POSTAGEM (
    id_postagem INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    texto_conteudo TEXT,
    tipo_postagem ENUM('texto', 'foto', 'video', 'enquete', 'galeria') DEFAULT 'texto',
    data_publicacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    localizacao VARCHAR(150),
    privacidade ENUM('publico', 'amigos', 'privado', 'personalizado') DEFAULT 'publico',
    permite_comentarios BOOLEAN DEFAULT TRUE,
    permite_compartilhamentos BOOLEAN DEFAULT TRUE,
    total_curtidas INT DEFAULT 0,
    total_comentarios INT DEFAULT 0,
    total_compartilhamentos INT DEFAULT 0,
    total_visualizacoes INT DEFAULT 0,
    em_destaque BOOLEAN DEFAULT FALSE,
    editado BOOLEAN DEFAULT FALSE,
    data_edicao TIMESTAMP NULL,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_usuario_data (id_usuario, data_publicacao DESC),
    INDEX idx_tipo_postagem (tipo_postagem),
    INDEX idx_data_publicacao (data_publicacao DESC)
);

-- Tabela: FOTO
CREATE TABLE FOTO (
    id_foto INT AUTO_INCREMENT PRIMARY KEY,
    id_postagem INT NULL,
    id_album INT NULL,
    id_usuario INT NOT NULL,
    url_foto VARCHAR(255) NOT NULL,
    url_thumbnail VARCHAR(255),
    legenda TEXT,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    largura INT,
    altura INT,
    tamanho_arquivo INT,
    ordem_galeria INT DEFAULT 1,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_postagem (id_postagem),
    INDEX idx_album (id_album)
);

-- Tabela: VIDEO
CREATE TABLE VIDEO (
    id_video INT AUTO_INCREMENT PRIMARY KEY,
    id_postagem INT NOT NULL,
    id_usuario INT NOT NULL,
    url_video VARCHAR(255) NOT NULL,
    thumbnail_url VARCHAR(255),
    legenda TEXT,
    duracao_segundos INT,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visualizacoes INT DEFAULT 0,
    qualidade ENUM('360p', '480p', '720p', '1080p', '4K') DEFAULT '720p',
    tamanho_arquivo BIGINT,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_postagem (id_postagem)
);

-- Tabela: ALBUM
CREATE TABLE ALBUM (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nome_album VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    privacidade ENUM('publico', 'amigos', 'privado') DEFAULT 'publico',
    foto_capa_url VARCHAR(255),
    total_fotos INT DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario)
);

ALTER TABLE FOTO
    ADD CONSTRAINT fk_foto_album
    FOREIGN KEY (id_album) REFERENCES ALBUM(id_album) ON DELETE SET NULL;

-- Tabela: STORY
CREATE TABLE STORY (
    id_story INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_midia ENUM('foto', 'video') NOT NULL,
    url_midia VARCHAR(255) NOT NULL,
    texto_overlay TEXT,
    cor_fundo VARCHAR(20),
    data_publicacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_expiracao TIMESTAMP NOT NULL,
    visualizacoes INT DEFAULT 0,
    permite_respostas BOOLEAN DEFAULT TRUE,
    destaque BOOLEAN DEFAULT FALSE,
    nome_destaque VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario),
    INDEX idx_expiracao (data_expiracao)
);

-- Tabela: VISUALIZACAO_STORY
CREATE TABLE VISUALIZACAO_STORY (
    id_story INT,
    id_usuario INT,
    data_visualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_story, id_usuario),
    FOREIGN KEY (id_story) REFERENCES STORY(id_story) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- Tabela: COMENTARIO
CREATE TABLE COMENTARIO (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    id_postagem INT NOT NULL,
    id_usuario INT NOT NULL,
    id_comentario_pai INT NULL,
    texto_comentario TEXT NOT NULL,
    data_comentario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    editado BOOLEAN DEFAULT FALSE,
    data_edicao TIMESTAMP NULL,
    total_curtidas INT DEFAULT 0,
    total_respostas INT DEFAULT 0,
    nivel_thread INT DEFAULT 0,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_comentario_pai) REFERENCES COMENTARIO(id_comentario) ON DELETE CASCADE,
    INDEX idx_postagem (id_postagem),
    INDEX idx_comentario_pai (id_comentario_pai),
    INDEX idx_data (data_comentario DESC)
);

-- Tabela: ENQUETE
CREATE TABLE ENQUETE (
    id_enquete INT AUTO_INCREMENT PRIMARY KEY,
    id_postagem INT NOT NULL,
    pergunta VARCHAR(255) NOT NULL,
    permite_multiplas_escolhas BOOLEAN DEFAULT FALSE,
    data_expiracao TIMESTAMP NULL,
    total_votos INT DEFAULT 0,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE
);

-- Tabela: OPCAO_ENQUETE
CREATE TABLE OPCAO_ENQUETE (
    id_opcao INT AUTO_INCREMENT PRIMARY KEY,
    id_enquete INT NOT NULL,
    texto_opcao VARCHAR(100) NOT NULL,
    total_votos INT DEFAULT 0,
    ordem INT DEFAULT 1,
    FOREIGN KEY (id_enquete) REFERENCES ENQUETE(id_enquete) ON DELETE CASCADE
);

-- Tabela: VOTO_ENQUETE
CREATE TABLE VOTO_ENQUETE (
    id_usuario INT,
    id_opcao INT,
    data_voto TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_opcao),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_opcao) REFERENCES OPCAO_ENQUETE(id_opcao) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO SOCIAL
-- ==========================================

-- Tabela: AMIZADE
CREATE TABLE AMIZADE (
    id_usuario1 INT,
    id_usuario2 INT,
    data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_amizade TIMESTAMP NULL,
    status_amizade ENUM('pendente', 'aceito', 'recusado', 'bloqueado') DEFAULT 'pendente',
    PRIMARY KEY (id_usuario1, id_usuario2),
    FOREIGN KEY (id_usuario1) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario2) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    CHECK (id_usuario1 < id_usuario2),
    INDEX idx_status (status_amizade)
);

-- Tabela: SEGUIR
CREATE TABLE SEGUIR (
    id_seguidor INT,
    id_seguido INT,
    data_inicio_seguir TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notificacoes_ativas BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id_seguidor, id_seguido),
    FOREIGN KEY (id_seguidor) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_seguido) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    CHECK (id_seguidor != id_seguido),
    INDEX idx_seguido (id_seguido),
    INDEX idx_seguidor (id_seguidor)
);

-- Tabela: BLOQUEIO
CREATE TABLE BLOQUEIO (
    id_usuario_bloqueador INT,
    id_usuario_bloqueado INT,
    data_bloqueio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo TEXT,
    PRIMARY KEY (id_usuario_bloqueador, id_usuario_bloqueado),
    FOREIGN KEY (id_usuario_bloqueador) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_bloqueado) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- Tabela: DENUNCIA
CREATE TABLE DENUNCIA (
    id_denuncia INT AUTO_INCREMENT PRIMARY KEY,
    id_denunciante INT NOT NULL,
    tipo_conteudo ENUM('postagem', 'comentario', 'usuario', 'mensagem', 'grupo') NOT NULL,
    id_conteudo INT NOT NULL,
    motivo ENUM('spam', 'ofensivo', 'fake', 'assedio', 'violencia', 'nudez', 'outro') NOT NULL,
    descricao TEXT,
    data_denuncia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente', 'analisando', 'resolvido', 'rejeitado') DEFAULT 'pendente',
    id_moderador INT NULL,
    resolucao TEXT,
    data_resolucao TIMESTAMP NULL,
    FOREIGN KEY (id_denunciante) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_moderador) REFERENCES USUARIO(id_usuario) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_tipo (tipo_conteudo)
);

-- ==========================================
-- MÓDULO DE GRUPOS
-- ==========================================

-- Tabela: GRUPO
CREATE TABLE GRUPO (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    id_criador INT NOT NULL,
    nome_grupo VARCHAR(100) NOT NULL,
    descricao TEXT,
    foto_grupo_url VARCHAR(255),
    foto_capa_url VARCHAR(255),
    categoria ENUM('tecnologia', 'esportes', 'arte', 'musica', 'cinema', 'educacao', 'jogos', 'viagens', 'outro') DEFAULT 'outro',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_grupo ENUM('publico', 'privado', 'secreto') DEFAULT 'publico',
    total_membros INT DEFAULT 1,
    total_postagens INT DEFAULT 0,
    regras_grupo TEXT,
    tags VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_criador) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_categoria (categoria),
    INDEX idx_tipo (tipo_grupo),
    FULLTEXT idx_nome_desc (nome_grupo, descricao)
);

-- Tabela: MEMBRO_GRUPO
CREATE TABLE MEMBRO_GRUPO (
    id_usuario INT,
    id_grupo INT,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    papel ENUM('membro', 'moderador', 'admin') DEFAULT 'membro',
    status ENUM('ativo', 'banido', 'saiu', 'pendente') DEFAULT 'ativo',
    convite_por INT NULL,
    PRIMARY KEY (id_usuario, id_grupo),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES GRUPO(id_grupo) ON DELETE CASCADE,
    FOREIGN KEY (convite_por) REFERENCES USUARIO(id_usuario) ON DELETE SET NULL,
    INDEX idx_grupo (id_grupo),
    INDEX idx_papel (papel)
);

-- Tabela: POSTAGEM_GRUPO
CREATE TABLE POSTAGEM_GRUPO (
    id_postagem INT,
    id_grupo INT,
    fixado BOOLEAN DEFAULT FALSE,
    aprovado BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id_postagem, id_grupo),
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES GRUPO(id_grupo) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO DE COMUNICAÇÃO
-- ==========================================

-- Tabela: CONVERSA
CREATE TABLE CONVERSA (
    id_conversa INT AUTO_INCREMENT PRIMARY KEY,
    tipo_conversa ENUM('individual', 'grupo') NOT NULL,
    nome_conversa VARCHAR(100),
    foto_conversa_url VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_atividade TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_ultima_atividade (ultima_atividade DESC)
);

-- Tabela: PARTICIPANTE_CONVERSA
CREATE TABLE PARTICIPANTE_CONVERSA (
    id_conversa INT,
    id_usuario INT,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_leitura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    silenciado BOOLEAN DEFAULT FALSE,
    papel ENUM('admin', 'membro') DEFAULT 'membro',
    ativo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id_conversa, id_usuario),
    FOREIGN KEY (id_conversa) REFERENCES CONVERSA(id_conversa) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario)
);

-- Tabela: MENSAGEM
CREATE TABLE MENSAGEM (
    id_mensagem INT AUTO_INCREMENT PRIMARY KEY,
    id_conversa INT NOT NULL,
    id_remetente INT NOT NULL,
    texto_mensagem TEXT,
    tipo_mensagem ENUM('texto', 'foto', 'video', 'audio', 'arquivo', 'localizacao', 'postagem_compartilhada') DEFAULT 'texto',
    url_anexo VARCHAR(255),
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    editada BOOLEAN DEFAULT FALSE,
    data_edicao TIMESTAMP NULL,
    deletada BOOLEAN DEFAULT FALSE,
    data_exclusao TIMESTAMP NULL,
    respondendo_id INT NULL,
    FOREIGN KEY (id_conversa) REFERENCES CONVERSA(id_conversa) ON DELETE CASCADE,
    FOREIGN KEY (id_remetente) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (respondendo_id) REFERENCES MENSAGEM(id_mensagem) ON DELETE SET NULL,
    INDEX idx_conversa_data (id_conversa, data_envio DESC),
    INDEX idx_remetente (id_remetente)
);

-- Tabela: LEITURA_MENSAGEM
CREATE TABLE LEITURA_MENSAGEM (
    id_mensagem INT,
    id_usuario INT,
    data_leitura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_mensagem, id_usuario),
    FOREIGN KEY (id_mensagem) REFERENCES MENSAGEM(id_mensagem) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO DE INTERAÇÕES
-- ==========================================

-- Tabela: CURTIDA
CREATE TABLE CURTIDA (
    id_usuario INT,
    id_postagem INT,
    data_curtida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_reacao ENUM('curtir', 'amar', 'haha', 'uau', 'triste', 'grr') DEFAULT 'curtir',
    PRIMARY KEY (id_usuario, id_postagem),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    INDEX idx_postagem (id_postagem),
    INDEX idx_tipo_reacao (tipo_reacao)
);

-- Tabela: CURTIDA_COMENTARIO
CREATE TABLE CURTIDA_COMENTARIO (
    id_usuario INT,
    id_comentario INT,
    data_curtida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_comentario),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_comentario) REFERENCES COMENTARIO(id_comentario) ON DELETE CASCADE
);

-- Tabela: COMPARTILHAMENTO
CREATE TABLE COMPARTILHAMENTO (
    id_compartilhamento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_postagem_original INT NOT NULL,
    data_compartilhamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    texto_adicional TEXT,
    privacidade ENUM('publico', 'amigos', 'privado') DEFAULT 'publico',
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_postagem_original) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario),
    INDEX idx_postagem (id_postagem_original),
    INDEX idx_data (data_compartilhamento DESC)
);

-- Tabela: SALVOS
CREATE TABLE SALVOS (
    id_usuario INT,
    id_postagem INT,
    data_salvamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    colecao VARCHAR(50) DEFAULT 'Geral',
    PRIMARY KEY (id_usuario, id_postagem),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    INDEX idx_usuario_colecao (id_usuario, colecao)
);

-- Tabela: TAG_FOTO
CREATE TABLE TAG_FOTO (
    id_usuario INT,
    id_foto INT,
    posicao_x DECIMAL(5,2),
    posicao_y DECIMAL(5,2),
    data_marcacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    confirmado BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_usuario, id_foto),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_foto) REFERENCES FOTO(id_foto) ON DELETE CASCADE
);

-- Tabela: HASHTAG
CREATE TABLE HASHTAG (
    id_hashtag INT AUTO_INCREMENT PRIMARY KEY,
    nome_hashtag VARCHAR(100) UNIQUE NOT NULL,
    total_usos INT DEFAULT 0,
    trending BOOLEAN DEFAULT FALSE,
    INDEX idx_nome (nome_hashtag),
    INDEX idx_trending (trending)
);

-- Tabela: POSTAGEM_HASHTAG
CREATE TABLE POSTAGEM_HASHTAG (
    id_postagem INT,
    id_hashtag INT,
    PRIMARY KEY (id_postagem, id_hashtag),
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    FOREIGN KEY (id_hashtag) REFERENCES HASHTAG(id_hashtag) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO DE NOTIFICAÇÕES
-- ==========================================

-- Tabela: NOTIFICACAO
CREATE TABLE NOTIFICACAO (
    id_notificacao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario_destino INT NOT NULL,
    id_usuario_origem INT NULL,
    tipo_notificacao ENUM('curtida', 'comentario', 'seguir', 'marcacao', 'amizade', 'grupo', 'compartilhamento', 'mensagem', 'resposta_story') NOT NULL,
    id_referencia INT,
    texto_notificacao VARCHAR(255),
    data_notificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lida BOOLEAN DEFAULT FALSE,
    data_leitura TIMESTAMP NULL,
    FOREIGN KEY (id_usuario_destino) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_origem) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_usuario_lida (id_usuario_destino, lida),
    INDEX idx_data (data_notificacao DESC)
);

-- ==========================================
-- MÓDULO MOVO LIVE
-- ==========================================

-- Tabela: LIVE
CREATE TABLE LIVE (
    id_live INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fim TIMESTAMP NULL,
    status_live ENUM('agendada', 'ao_vivo', 'encerrada') DEFAULT 'agendada',
    espectadores_pico INT DEFAULT 0,
    total_visualizacoes INT DEFAULT 0,
    url_stream VARCHAR(255),
    url_replay VARCHAR(255),
    permite_comentarios BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_status (status_live),
    INDEX idx_usuario (id_usuario)
);

-- Tabela: ESPECTADOR_LIVE
CREATE TABLE ESPECTADOR_LIVE (
    id_live INT,
    id_usuario INT,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_saida TIMESTAMP NULL,
    PRIMARY KEY (id_live, id_usuario, data_entrada),
    FOREIGN KEY (id_live) REFERENCES LIVE(id_live) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO MOVO EVENTOS
-- ==========================================

-- Tabela: EVENTO
CREATE TABLE EVENTO (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    id_criador INT NOT NULL,
    nome_evento VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora_inicio TIMESTAMP NOT NULL,
    data_hora_fim TIMESTAMP NULL,
    localizacao VARCHAR(200),
    tipo_evento ENUM('presencial', 'online', 'hibrido') DEFAULT 'presencial',
    url_evento VARCHAR(255),
    total_confirmados INT DEFAULT 0,
    total_interessados INT DEFAULT 0,
    capacidade_maxima INT NULL,
    foto_evento_url VARCHAR(255),
    privacidade ENUM('publico', 'privado') DEFAULT 'publico',
    FOREIGN KEY (id_criador) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_data_inicio (data_hora_inicio),
    INDEX idx_criador (id_criador)
);

-- Tabela: PARTICIPANTE_EVENTO
CREATE TABLE PARTICIPANTE_EVENTO (
    id_evento INT,
    id_usuario INT,
    status_participacao ENUM('confirmado', 'interessado', 'nao_vai', 'talvez') DEFAULT 'interessado',
    data_resposta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_evento, id_usuario),
    FOREIGN KEY (id_evento) REFERENCES EVENTO(id_evento) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO MOEDAS MOVO
-- ==========================================

-- Tabela: MOEDA_MOVO
CREATE TABLE MOEDA_MOVO (
    id_transacao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_transacao ENUM('ganho', 'gasto', 'compra', 'presente') NOT NULL,
    quantidade INT NOT NULL,
    descricao VARCHAR(255),
    origem ENUM('postagem', 'curtidas', 'comentarios', 'login_diario', 'conquista', 'compra', 'presente_recebido', 'destaque_post', 'presente_enviado', 'outro') NOT NULL,
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    saldo_anterior INT NOT NULL,
    saldo_novo INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    INDEX idx_usuario (id_usuario),
    INDEX idx_data (data_transacao DESC)
);

-- Tabela: SALDO_MOEDA
CREATE TABLE SALDO_MOEDA (
    id_usuario INT PRIMARY KEY,
    saldo_atual INT DEFAULT 0,
    total_ganho INT DEFAULT 0,
    total_gasto INT DEFAULT 0,
    ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- ==========================================
-- MÓDULO CONQUISTAS
-- ==========================================

-- Tabela: CONQUISTA
CREATE TABLE CONQUISTA (
    id_conquista INT AUTO_INCREMENT PRIMARY KEY,
    nome_conquista VARCHAR(100) NOT NULL,
    descricao TEXT,
    icone_url VARCHAR(255),
    criterio VARCHAR(255),
    recompensa_moedas INT DEFAULT 0,
    raridade ENUM('comum', 'rara', 'epica', 'lendaria') DEFAULT 'comum',
    ativa BOOLEAN DEFAULT TRUE
);

-- Tabela: USUARIO_CONQUISTA
CREATE TABLE USUARIO_CONQUISTA (
    id_usuario INT,
    id_conquista INT,
    data_desbloqueio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    exibir_perfil BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id_usuario, id_conquista),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_conquista) REFERENCES CONQUISTA(id_conquista) ON DELETE CASCADE
);

-- ==========================================
-- TRIGGERS E PROCEDURES
-- ==========================================

-- noqa: disable=PRS
-- Trigger: Atualizar contador de curtidas
DELIMITER //
CREATE TRIGGER after_curtida_insert
AFTER INSERT ON CURTIDA
FOR EACH ROW
BEGIN
    UPDATE POSTAGEM 
    SET total_curtidas = total_curtidas + 1 
    WHERE id_postagem = NEW.id_postagem;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_curtida_delete
AFTER DELETE ON CURTIDA
FOR EACH ROW
BEGIN
    UPDATE POSTAGEM 
    SET total_curtidas = total_curtidas - 1 
    WHERE id_postagem = OLD.id_postagem;
END//
DELIMITER ;

-- Trigger: Atualizar contador de comentários
DELIMITER //
CREATE TRIGGER after_comentario_insert
AFTER INSERT ON COMENTARIO
FOR EACH ROW
BEGIN
    UPDATE POSTAGEM 
    SET total_comentarios = total_comentarios + 1 
    WHERE id_postagem = NEW.id_postagem;
    
    IF NEW.id_comentario_pai IS NOT NULL THEN
        UPDATE COMENTARIO
        SET total_respostas = total_respostas + 1
        WHERE id_comentario = NEW.id_comentario_pai;
    END IF;
END//
DELIMITER ;

-- Trigger: Criar notificação ao curtir
DELIMITER //
CREATE TRIGGER after_curtida_notificacao
AFTER INSERT ON CURTIDA
FOR EACH ROW
BEGIN
    DECLARE autor_post INT;
    SELECT id_usuario INTO autor_post FROM POSTAGEM WHERE id_postagem = NEW.id_postagem;
    
    IF autor_post != NEW.id_usuario THEN
        INSERT INTO NOTIFICACAO (id_usuario_destino, id_usuario_origem, tipo_notificacao, id_referencia)
        VALUES (autor_post, NEW.id_usuario, 'curtida', NEW.id_postagem);
    END IF;
END//
DELIMITER ;

-- Trigger: Expirar stories automaticamente
DELIMITER //
CREATE EVENT expirar_stories
ON SCHEDULE EVERY 1 HOUR
DO
    DELETE FROM STORY 
    WHERE data_expiracao < NOW() AND destaque = FALSE;
//
DELIMITER ;
-- noqa: enable=PRS

-- ==========================================
-- DADOS INICIAIS - CONQUISTAS
-- ==========================================

INSERT INTO CONQUISTA (nome_conquista, descricao, icone_url, criterio, recompensa_moedas, raridade) VALUES
('Primeiro Post', 'Publique sua primeira postagem no MOVO', '/badges/primeiro_post.png', 'total_posts >= 1', 50, 'comum'),
('Social', 'Tenha 10 amigos no MOVO', '/badges/social.png', 'total_amigos >= 10', 100, 'comum'),
('Influencer', 'Alcance 1000 seguidores', '/badges/influencer.png', 'total_seguidores >= 1000', 500, 'rara'),
('Fotógrafo', 'Poste 50 fotos', '/badges/fotografo.png', 'total_fotos >= 50', 200, 'rara'),
('Comentarista', 'Faça 100 comentários', '/badges/comentarista.png', 'total_comentarios_feitos >= 100', 150, 'comum'),
('Viral', 'Tenha um post com 1000 curtidas', '/badges/viral.png', 'post_curtidas >= 1000', 1000, 'epica'),
('Lenda MOVO', 'Esteja no MOVO por 1 ano', '/badges/lenda.png', 'dias_cadastro >= 365', 2000, 'lendaria');

-- ==========================================
-- VIEWS ÚTEIS
-- ==========================================

-- View: Feed do usuário
CREATE VIEW v_feed_usuario AS
SELECT 
    p.id_postagem,
    p.id_usuario,
    u.nome_usuario,
    u.nome_completo,
    u.foto_perfil_url,
    u.conta_verificada,
    p.texto_conteudo,
    p.tipo_postagem,
    p.data_publicacao,
    p.localizacao,
    p.total_curtidas,
    p.total_comentarios,
    p.total_compartilhamentos,
    p.total_visualizacoes
FROM POSTAGEM p
INNER JOIN USUARIO u ON p.id_usuario = u.id_usuario
WHERE u.status_conta = 'ativo';

-- View: Posts mais populares
CREATE VIEW v_trending_posts AS
SELECT 
    p.*,
    u.nome_usuario,
    u.foto_perfil_url,
    (p.total_curtidas * 2 + p.total_comentarios * 3 + p.total_compartilhamentos * 5 + p.total_visualizacoes * 0.1) AS score_engajamento
FROM POSTAGEM p
INNER JOIN USUARIO u ON p.id_usuario = u.id_usuario
WHERE p.data_publicacao >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
    AND p.privacidade = 'publico'
ORDER BY score_engajamento DESC;

-- ==========================================
-- ÍNDICES ADICIONAIS PARA PERFORMANCE
-- ==========================================

CREATE INDEX idx_postagem_privacidade ON POSTAGEM(privacidade);
CREATE INDEX idx_story_ativo ON STORY(data_expiracao);
CREATE INDEX idx_mensagem_conversa_data ON MENSAGEM(id_conversa, data_envio DESC);
CREATE INDEX idx_notificacao_nao_lida ON NOTIFICACAO(id_usuario_destino, lida, data_notificacao DESC);

-- ==========================================
-- FIM DO SCHEMA MOVO
-- ============================================
