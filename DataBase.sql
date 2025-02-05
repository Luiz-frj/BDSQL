CREATE DATABASE SmartMirrorFit;

-- Sequences para gerar valores únicos para as chaves primárias
CREATE SEQUENCE seq_usuarios START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_produtos_servicos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_compras START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_planos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_assinaturas START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_estoque START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_fornecedores START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pedidos_compra START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pagamentos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cargos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_funcionarios START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_localizacao START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_beneficios START WITH 1 INCREMENT BY 1;

-- Triggers para garantir a integridade dos dados e automatizar tarefas
CREATE OR REPLACE TRIGGER trg_before_insert_compras
BEFORE INSERT ON Compras
FOR EACH ROW
BEGIN
    SELECT seq_compras.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER trg_before_insert_pagamentos
BEFORE INSERT ON Pagamentos
FOR EACH ROW
BEGIN
    SELECT seq_pagamentos.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

-- Procedures para executar tarefas complexas no banco de dados
CREATE OR REPLACE PROCEDURE add_usuario (
    p_nome IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    INSERT INTO Usuarios (nome, email) VALUES (p_nome, p_email);
    COMMIT;
END;
/

-- Functions para realizar cálculos e retornar valores
CREATE OR REPLACE FUNCTION calcular_total_gasto (
    p_usuario_id IN NUMBER
) RETURN NUMBER AS
    v_total NUMBER := 0;
BEGIN
    SELECT COALESCE(SUM(valor), 0) INTO v_total FROM Pagamentos WHERE usuario_id = p_usuario_id;
    RETURN v_total;
END;
/

-- Views para simplificar consultas e fornecer diferentes perspectivas dos dados
CREATE OR REPLACE VIEW vw_compras_usuarios AS
SELECT c.id, u.nome AS usuario, p.nome AS produto, c.data_compra
FROM Compras c
JOIN Usuarios u ON c.usuario_id = u.id
JOIN ProdutosServicos p ON c.produto_id = p.id;

-- Tabela de Usuários
CREATE TABLE Usuarios (
    id NUMBER PRIMARY KEY DEFAULT seq_usuarios.NEXTVAL,
    nome VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) UNIQUE NOT NULL
);

-- Tabela de Produtos e Serviços
CREATE TABLE ProdutosServicos (
    id NUMBER PRIMARY KEY DEFAULT seq_produtos_servicos.NEXTVAL,
    nome VARCHAR2(255) NOT NULL,
    descricao CLOB,
    preco NUMBER(10,2),
    categoria VARCHAR2(100),
    status VARCHAR2(20) CHECK (status IN ('Disponível', 'Em Desenvolvimento', 'Indisponível'))
);

-- Tabela de Compras
CREATE TABLE Compras (
    id NUMBER PRIMARY KEY DEFAULT seq_compras.NEXTVAL,
    usuario_id NUMBER NOT NULL,
    produto_id NUMBER NOT NULL,
    data_compra DATE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (produto_id) REFERENCES ProdutosServicos(id)
);

-- Tabela de Planos
CREATE TABLE Planos (
    id NUMBER PRIMARY KEY DEFAULT seq_planos.NEXTVAL,
    nome VARCHAR2(255) NOT NULL,
    preco NUMBER(10,2) NOT NULL
);

-- Tabela de Assinaturas
CREATE TABLE Assinaturas (
    id NUMBER PRIMARY KEY DEFAULT seq_assinaturas.NEXTVAL,
    usuario_id NUMBER NOT NULL,
    plano_id NUMBER NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (plano_id) REFERENCES Planos(id)
);

-- Tabela de Estoque
CREATE TABLE Estoque (
    id NUMBER PRIMARY KEY DEFAULT seq_estoque.NEXTVAL,
    produto_id NUMBER UNIQUE NOT NULL,
    quantidade NUMBER NOT NULL,
    localizacao_id NUMBER,
    FOREIGN KEY (produto_id) REFERENCES ProdutosServicos(id),
    FOREIGN KEY (localizacao_id) REFERENCES Localizacao(id)
);

-- Tabela de Fornecedores
CREATE TABLE Fornecedores (
    id NUMBER PRIMARY KEY DEFAULT seq_fornecedores.NEXTVAL,
    nome VARCHAR2(255) NOT NULL
);

-- Tabela de Relacionamento Produto-Fornecedor
CREATE TABLE ProdutoFornecedor (
    fornecedor_id NUMBER NOT NULL,
    produto_id NUMBER NOT NULL,
    PRIMARY KEY (fornecedor_id, produto_id),
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id),
    FOREIGN KEY (produto_id) REFERENCES ProdutosServicos(id)
);

-- Tabela de Pedidos de Compra
CREATE TABLE PedidosCompra (
    id NUMBER PRIMARY KEY DEFAULT seq_pedidos_compra.NEXTVAL,
    fornecedor_id NUMBER NOT NULL,
    data_pedido DATE NOT NULL,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id)
);

-- Tabela de Itens do Pedido
CREATE TABLE ItensPedido (
    pedido_id NUMBER NOT NULL,
    produto_id NUMBER NOT NULL,
    quantidade NUMBER NOT NULL,
    PRIMARY KEY (pedido_id, produto_id),
    FOREIGN KEY (pedido_id) REFERENCES PedidosCompra(id),
    FOREIGN KEY (produto_id) REFERENCES ProdutosServicos(id)
);

-- Tabela de Pagamentos
CREATE TABLE Pagamentos (
    id NUMBER PRIMARY KEY DEFAULT seq_pagamentos.NEXTVAL,
    usuario_id NUMBER NOT NULL,
    valor NUMBER(10,2) NOT NULL,
    data_pagamento DATE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

-- Tabela de Cargos
CREATE TABLE Cargos (
    id NUMBER PRIMARY KEY DEFAULT seq_cargos.NEXTVAL,
    nome VARCHAR2(255) NOT NULL,
    salario NUMBER(10,2)
);

-- Tabela de Funcionários
CREATE TABLE Funcionarios (
    id NUMBER PRIMARY KEY DEFAULT seq_funcionarios.NEXTVAL,
    nome VARCHAR2(255) NOT NULL,
    cargo_id NUMBER NOT NULL,
    FOREIGN KEY (cargo_id) REFERENCES Cargos(id)
);

-- Tabela de Localização
CREATE TABLE Localizacao (
    id NUMBER PRIMARY KEY DEFAULT seq_localizacao.NEXTVAL,
    endereco VARCHAR2(255) NOT NULL,
    cidade VARCHAR2(100) NOT NULL,
    estado VARCHAR2(100) NOT NULL,
    cep VARCHAR2(20)
);

-- Tabela de Benefícios
CREATE TABLE Beneficios (
    id NUMBER PRIMARY KEY DEFAULT seq_beneficios.NEXTVAL,
    plano_id NUMBER NOT NULL,
    descricao CLOB NOT NULL,
    FOREIGN KEY (plano_id) REFERENCES Planos(id)
);

-- Inserção de dados para testes
INSERT INTO Usuarios (nome, email) VALUES ('Maria Souza', 'maria@email.com');
INSERT INTO Pagamentos (usuario_id, valor, data_pagamento) VALUES (1, 100.00, SYSDATE);
SELECT calcular_total_gasto(1) FROM DUAL;
