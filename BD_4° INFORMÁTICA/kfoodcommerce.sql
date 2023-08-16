CREATE DATABASE IF NOT EXISTS kfoodcommerce;
USE kfoodcommerce;

CREATE TABLE tbclientes (
  codcliente INT AUTO_INCREMENT,
  nomecliente VARCHAR(50) NOT NULL,
  cpfcliente BIGINT(12) NOT NULL,
  telefonecliente BIGINT(12) NOT NULL,
  ativo VARCHAR(1) NOT NULL DEFAULT 'S' COMMENT 'default "S"',
  tipocliente VARCHAR(2) NOT NULL DEFAULT 'C' COMMENT 'ou será cliente ou será administrador',
  email VARCHAR(50) NOT NULL,
  senha VARCHAR(25) NOT NULL,
  PRIMARY KEY (codcliente),
  CONSTRAINT ck_tipocliente CHECK (tipocliente IN ('C', 'A')), -- Fixed typo
  CONSTRAINT ck_ativo CHECK (ativo IN ('S', 'N')) -- Fixed typo
) ENGINE = InnoDB;

CREATE TABLE tbcidades (
  codcidade INT NOT NULL,
  nomecidade VARCHAR(50) NOT NULL,
  estadocidade VARCHAR(50) NOT NULL,
  PRIMARY KEY (codcidade),
  CONSTRAINT check_estadocidade CHECK (estadocidade = 'PR')
) ENGINE = InnoDB;

INSERT INTO tbcidades (codcidade, nomecidade, estadocidade) VALUES
(2853, 'Cascavel', 'PR');

CREATE TABLE tbenderecos (
  codendereco INT AUTO_INCREMENT,
  ruaresidencia VARCHAR(50) NOT NULL,
  numeroresidencia INT NOT NULL,
  bairrodaresidencia VARCHAR(50) NOT NULL,
  complementoresidencia VARCHAR(50) NOT NULL,
  fk_codcliente INT NOT NULL,
  fk_codcidade INT NOT NULL,
  PRIMARY KEY (codendereco),
  INDEX fk_tbenderecos_tbclientes_idx (fk_codcliente ASC),
  INDEX fk_tbenderecos_tbcidades_idx (fk_codcidade ASC),
  FOREIGN KEY (fk_codcliente) REFERENCES tbclientes(codcliente),
  FOREIGN KEY (fk_codcidade) REFERENCES tbcidades(codcidade)
) ENGINE = InnoDB;

CREATE TABLE tbpedidos (
  codpedido INT AUTO_INCREMENT,
  taxaentrega INT NOT NULL,
  tipopagamento VARCHAR(8) NOT NULL DEFAULT 'PIX' COMMENT 'os dois únicos pagamentos que têm a possibilidade são dinheiro ou PIX',
  movimento VARCHAR(8) NOT NULL COMMENT 'movimento IN (\'entregar\', \'retirar\')',
  data DATE NOT NULL,
  fk_codcliente INT NOT NULL,
  fk_codendereco INT NOT NULL,
  PRIMARY KEY (codpedido),
  INDEX fk_tbpedidos_tbclientes_idx (fk_codcliente ASC),
  INDEX fk_tbpedidos_tbenderecos_idx (fk_codendereco ASC),
  FOREIGN KEY (fk_codcliente) REFERENCES tbclientes(codcliente),
  FOREIGN KEY (fk_codendereco) REFERENCES tbenderecos(codendereco)
) ENGINE = InnoDB;

CREATE TABLE tbprodutos (
  codproduto INT AUTO_INCREMENT,
  nomeproduto VARCHAR(50) NOT NULL,
  tipoproduto VARCHAR(10) NOT NULL,
  ativo VARCHAR(1) NOT NULL DEFAULT 'S' COMMENT 'Se estiver ativado será "S" caso não será "N"',
  imagem VARCHAR(255) NOT NULL,
  descproduto VARCHAR(200) NOT NULL,
  pesoprod FLOAT NOT NULL,
  valorprod FLOAT NOT NULL,
  gluten VARCHAR(1) NOT NULL,
  PRIMARY KEY (codproduto)
) ENGINE = InnoDB;

CREATE TABLE tbprodutospedidos (
  fk_codproduto INT NOT NULL,
  fk_codpedido INT NOT NULL,
  codprodutopedido INT NOT NULL,
  valorproduto FLOAT(4,2) NOT NULL,
  quantprod INT NOT NULL,
  PRIMARY KEY (codprodutopedido),
  INDEX fk_tbprodutos_has_tbpedidos_tbpedidos_idx (fk_codpedido ASC),
  INDEX fk_tbprodutos_has_tbpedidos_tbprodutos_idx (fk_codproduto ASC),
  FOREIGN KEY (fk_codpedido) REFERENCES tbpedidos(codpedido),
  FOREIGN KEY (fk_codproduto) REFERENCES tbprodutos(codproduto)
) ENGINE = InnoDB;
