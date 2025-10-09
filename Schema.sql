-- ============================================
-- MODELAGEM DE BANCO DE DADOS - REDE SOCIAL
-- ============================================

-- Tabela: USUARIO
CREATE TABLE USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    nome_usuario VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_nascimento DATE,
    sexo CHAR(1),
    bio TEXT,
    foto_perfil_url VARCHAR(255),
    foto_capa_url VARCHAR(255),
    cidade VARCHAR(100),
    pais VARCHAR(50),
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acesso TIMESTAMP,
    conta_verificada BOOLEAN DEFAULT FALSE,
    conta_privada BOOLEAN DEFAULT FALSE,
    status_conta ENUM('ativo', 'inativo', 'suspenso') DEFAULT 'ativo'
);

-- Tabela: POSTAGEM
CREATE TABLE POSTAGEM (
    id_postagem INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    texto_conteudo TEXT,
    tipo_postagem ENUM('texto', 'foto', 'video', 'enquete') DEFAULT 'texto',
    data_publicacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    localizacao VARCHAR(150),
    privacidade ENUM('publico', 'amigos', 'privado') DEFAULT 'publico',
    permite_comentarios BOOLEAN DEFAULT TRUE,
    total_curtidas INT DEFAULT 0,
    total_comentarios INT DEFAULT 0,
    total_compartilhamentos INT DEFAULT 0,
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
    total_curtidas INT DEFAULT 0,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_comentario_pai) REFERENCES COMENTARIO(id_comentario) ON DELETE CASCADE
);

-- Tabela: FOTO
CREATE TABLE FOTO (
    id_foto INT AUTO_INCREMENT PRIMARY KEY,
    id_postagem INT NULL,
    id_album INT NULL,
    url_foto VARCHAR(255) NOT NULL,
    legenda TEXT,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    largura INT,
    altura INT,
    tamanho_arquivo INT,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE,
    FOREIGN KEY (id_album) REFERENCES ALBUM(id_album) ON DELETE SET NULL
);

-- Tabela: VIDEO
CREATE TABLE VIDEO (
    id_video INT AUTO_INCREMENT PRIMARY KEY,
    id_postagem INT NOT NULL,
    url_video VARCHAR(255) NOT NULL,
    thumbnail_url VARCHAR(255),
    legenda TEXT,
    duracao_segundos INT,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visualizacoes INT DEFAULT 0,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE
);

-- Tabela: ALBUM
CREATE TABLE ALBUM (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nome_album VARCHAR(100) NOT NULL,
    descricao TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    privacidade ENUM('publico', 'amigos', 'privado') DEFAULT 'publico',
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- Tabela: GRUPO
CREATE TABLE GRUPO (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    id_criador INT NOT NULL,
    nome_grupo VARCHAR(100) NOT NULL,
    descricao TEXT,
    foto_grupo_url VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_grupo ENUM('publico', 'privado', 'secreto') DEFAULT 'publico',
    total_membros INT DEFAULT 1,
    FOREIGN KEY (id_criador) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- Tabela: MENSAGEM
CREATE TABLE MENSAGEM (
    id_mensagem INT AUTO_INCREMENT PRIMARY KEY,
    id_remetente INT NOT NULL,
    id_destinatario INT NOT NULL,
    texto_mensagem TEXT NOT NULL,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lida BOOLEAN DEFAULT FALSE,
    data_leitura TIMESTAMP NULL,
    FOREIGN KEY (id_remetente) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_destinatario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- Tabela: NOTIFICACAO
CREATE TABLE NOTIFICACAO (
    id_notificacao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario_destino INT NOT NULL,
    id_usuario_origem INT NULL,
    tipo_notificacao ENUM('curtida', 'comentario', 'seguir', 'marcacao', 'amizade', 'grupo', 'compartilhamento') NOT NULL,
    id_referencia INT,
    texto_notificacao VARCHAR(255),
    data_notificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_usuario_destino) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario_origem) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE
);

-- ==========================================
-- TABELAS INTERMEDIÁRIAS (Relacionamentos N:M)
-- ==========================================

-- Tabela: AMIZADE (Usuário x Usuário)
CREATE TABLE AMIZADE (
    id_usuario1 INT,
    id_usuario2 INT,
    data_amizade TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_amizade ENUM('pendente', 'aceito', 'bloqueado') DEFAULT 'pendente',
    PRIMARY KEY (id_usuario1, id_usuario2),
    FOREIGN KEY (id_usuario1) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario2) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    CHECK (id_usuario1 < id_usuario2)
);

-- Tabela: SEGUIR (Seguidor x Seguido)
CREATE TABLE SEGUIR (
    id_seguidor INT,
    id_seguido INT,
    data_inicio_seguir TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_seguidor, id_seguido),
    FOREIGN KEY (id_seguidor) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_seguido) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    CHECK (id_seguidor != id_seguido)
);

-- Tabela: CURTIDA (Usuário x Postagem)
CREATE TABLE CURTIDA (
    id_usuario INT,
    id_postagem INT,
    data_curtida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_reacao ENUM('curtir', 'amar', 'haha', 'uau', 'triste', 'grr') DEFAULT 'curtir',
    PRIMARY KEY (id_usuario, id_postagem),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE
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

-- Tabela: MEMBRO_GRUPO
CREATE TABLE MEMBRO_GRUPO (
    id_usuario INT,
    id_grupo INT,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    papel ENUM('membro', 'moderador', 'admin') DEFAULT 'membro',
    status ENUM('ativo', 'banido', 'saiu') DEFAULT 'ativo',
    PRIMARY KEY (id_usuario, id_grupo),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES GRUPO(id_grupo) ON DELETE CASCADE
);

-- Tabela: TAG_FOTO (Marcações em fotos)
CREATE TABLE TAG_FOTO (
    id_usuario INT,
    id_foto INT,
    posicao_x DECIMAL(5,2),
    posicao_y DECIMAL(5,2),
    data_marcacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_foto),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_foto) REFERENCES FOTO(id_foto) ON DELETE CASCADE
);

-- Tabela: COMPARTILHAMENTO
CREATE TABLE COMPARTILHAMENTO (
    id_usuario INT,
    id_postagem INT,
    data_compartilhamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    texto_adicional TEXT,
    PRIMARY KEY (id_usuario, id_postagem, data_compartilhamento),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE
);

-- Tabela: SALVOS (Postagens salvas)
CREATE TABLE SALVOS (
    id_usuario INT,
    id_postagem INT,
    data_salvamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    colecao VARCHAR(50) DEFAULT 'Geral',
    PRIMARY KEY (id_usuario, id_postagem),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_postagem) REFERENCES POSTAGEM(id_postagem) ON DELETE CASCADE
);

-- ==========================================
-- ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS
-- ==========================================

CREATE INDEX idx_postagem_usuario ON POSTAGEM(id_usuario);
CREATE INDEX idx_postagem_data ON POSTAGEM(data_publicacao DESC);
CREATE INDEX idx_comentario_postagem ON COMENTARIO(id_postagem);
CREATE INDEX idx_mensagem_destinatario ON MENSAGEM(id_destinatario);
CREATE INDEX idx_notificacao_usuario ON NOTIFICACAO(id_usuario_destino);
CREATE INDEX idx_seguir_seguido ON SEGUIR(id_seguido);
CREATE INDEX idx_amizade_status ON AMIZADE(status_amizade);
