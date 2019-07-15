CREATE DATABASE marilde;
\c marilde;
CREATE TABLE edital(
    codigo SERIAL PRIMARY KEY,
    data_abertura DATE NOT NULL,
    data_encerramento DATE NULL,
    justificativa TEXT NOT NULL,
    tipo VARCHAR(30) NOT NULL, -- pode ser de Projetos, Cursos, Eventos, Consultorias, Publicações, Produtos, eventos ou palestras
    titulo VARCHAR(130) NOT NULL,
    reoferta BOOLEAN NOT NULL
);

CREATE TABLE bolsa(
    codigo_edital INT NOT NULL,
    bolsa VARCHAR(100),
    
    PRIMARY KEY (codigo_edital,bolsa),
    CONSTRAINT bolsa_fk_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo)
);

CREATE TABLE proponente(
    codigo_edital INT NOT NULL,
    proponente VARCHAR(30),
    
    PRIMARY KEY (codigo_edital,proponente),
    CONSTRAINT proponente_fk_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo)
);

CREATE TABLE objetivo(
    codigo_edital INT NOT NULL,
    objetivo VARCHAR(50),
    
    PRIMARY KEY (codigo_edital,objetivo),
    CONSTRAINT objetivo_fk_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo)
);

CREATE TABLE cronograma(
    codigo_edital INT NOT NULL,
    atividade VARCHAR(50),
    data DATE,
    
    PRIMARY KEY (codigo_edital,atividade,data),
    CONSTRAINT cronograma_fk_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo)
);

CREATE TABLE disposicoes_gerais(
    codigo_edital INT NOT NULL,
    disposicao VARCHAR(150),
    
    PRIMARY KEY (codigo_edital,disposicao),
    CONSTRAINT disposicoes_fk_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo)
);

CREATE TABLE edital_atividade(
    codigo_edital INT NOT NULL PRIMARY KEY,

    CONSTRAINT edital_atividade_fk_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo)
);

CREATE TABLE edital_programa(
    codigo_edital INT NOT NULL PRIMARY KEY,

    CONSTRAINT edital_programa_fk_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo)
);

CREATE TABLE orgao_avaliador(
    id_orgao SERIAL,
    sigla VARCHAR(10) NOT NULL,
    nome VARCHAR(130) NOT NULL,
    CONSTRAINT pk_orgao PRIMARY KEY(id_orgao)
);
 
/*Pessoa(PK(id_pessoa), nome, senha, uf, cidade, bairro, rua, numero);*/
CREATE TABLE Pessoa
(
    id_pessoa SERIAL CONSTRAINT pk_pessoa PRIMARY KEY,
    nome VARCHAR(30) CONSTRAINT pessoa_nome_nnu NOT NULL,
    senha VARCHAR(30) CONSTRAINT pessoa_senha_nnu NOT NULL,
    uf VARCHAR(2),
    cidade VARCHAR(30),
    bairro VARCHAR(30),
    rua VARCHAR(30),
    numero INT
);

/*Pessoa_Telefone(PK(FK_Pessoa(id_pessoa), fixo, ddd, ddi));*/
CREATE TABLE Pessoa_Telefone
(
    id_pessoa INT NOT NULL,
    fixo VARCHAR(9) NOT NULL,
    ddd CHAR(2) NOT NULL,
    ddi VARCHAR(4),
    
    CONSTRAINT pk_pessoa_telefone PRIMARY KEY (id_pessoa, fixo, ddd, ddi),
    CONSTRAINT fk_pessoa_telefone_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

/*Pessoa_Email(PK(FK_Pessoa(id_pessoa), email));*/
CREATE TABLE Pessoa_Email
(
    id_pessoa INT NOT NULL,
    email VARCHAR(30) NOT NULL,
    
    CONSTRAINT pk_pessoa_email PRIMARY KEY (id_pessoa, email),
    CONSTRAINT fk_pessoa_email_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

/*PessoaBrasileira(PK(cpf), FK_Pessoa(id_pessoa));*/
CREATE TABLE PessoaBrasileira
(
    cpf CHAR(11) NOT NULL,
    id_pessoa INT NOT NULL,
    
    CONSTRAINT pk_pessoaBrasileira PRIMARY KEY (id_pessoa, cpf),
    CONSTRAINT fk_pessoaBrasileira_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

/*PessoaEstrangeira(PK(passaporte), FK_Pessoa(id_pessoa));*/
CREATE TABLE PessoaEstrangeira
(
    passaporte CHAR(8) NOT NULL,
    id_pessoa INT NOT NULL,
    
    CONSTRAINT pk_pessoaEstrangeira PRIMARY KEY (id_pessoa, passaporte),
    CONSTRAINT fk_pessoaEstrangeira_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

/*Departamento(PK(id_departamento), nome);*/
CREATE TABLE Departamento
(
    id_departamento SERIAL CONSTRAINT pk_departamento PRIMARY KEY,
    nome VARCHAR(65)
);

/*PessoaGraduacao(PK(FK_Pessoa(id_pessoa)), nro_ufscar);*/
CREATE TABLE PessoaGraduacao
(
    id_pessoa INT NOT NULL,
    nro_ufscar INT NOT NULL,
    
    CONSTRAINT pk_pessoaGraduacao PRIMARY KEY (id_pessoa),
    CONSTRAINT fk_pessoaGraduacao_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

/*PessoaPosgraduacao(PK(FK_Pessoa(id_pessoa)), nro_ufscar);*/
CREATE TABLE PessoaPosgraduacao
(
    id_pessoa INT NOT NULL,
    nro_ufscar INT NOT NULL,
    
    CONSTRAINT pk_pessoaposgraduacao PRIMARY KEY (id_pessoa),
    CONSTRAINT fk_pessoaposgraduacao_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);


/*PessoaServidor(PK(FK_Pessoa(id_pessoa), FK_Departamento(id_departamento)), nro_ufscar, data_contratacao);*/
CREATE TABLE PessoaServidor
(
    id_pessoa INT,
    id_departamento INT CONSTRAINT fk_pessoaServidor_departamento REFERENCES Departamento(id_departamento),
    nro_ufscar INT UNIQUE NOT NULL,
    data_contratacao DATE,
    CONSTRAINT pk_pessoaServidor PRIMARY KEY (id_pessoa, id_departamento),
    CONSTRAINT fk_pessoaServidor FOREIGN Key (id_pessoa) REFERENCES Pessoa(id_pessoa)    
);

/*PessoaServidorDocente(PK(FK_PessoaServidor(id_pessoa, id_departamento)), titulo, cargo, setor, tipo, data_ingresso);*/

CREATE TABLE PessoaServidorDocente
(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    titulo VARCHAR(30) NOT NULL,
    cargo VARCHAR(30) NOT NULL,
    setor VARCHAR(30) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    data_ingresso DATE,
    CONSTRAINT pk_pessoaservidordocente PRIMARY KEY (id_pessoa, id_departamento),
    CONSTRAINT fk_pessoaservidordocente_pessoaservidor FOREIGN KEY (id_pessoa, id_departamento) REFERENCES PessoaServidor(id_pessoa, id_departamento)
);

/*PessoaServidorTecnico(PK(FK_PessoaServidor(id_pessoa, id_departamento)));*/

CREATE TABLE PessoaServidorTecnico
(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT fk_pessoaservidortecnico_pessoaservidor FOREIGN KEY (id_pessoa, id_departamento) REFERENCES PessoaServidor(id_pessoa, id_departamento),
    CONSTRAINT pk_pessoaservidortecnico PRIMARY KEY (id_pessoa, id_departamento)
);

/*Curso(PK(id_curso), FK_Departamento(id_departamento));*/

CREATE TABLE Curso
(
    id_curso SERIAL NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT fk_curso_departamento FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento),
    CONSTRAINT pk_curso PRIMARY KEY (id_curso)
);

/*Financiador(PK(id_financiador), agencia, tipo_controle);*/

CREATE TABLE Financiador
(
    id_financiador SERIAL NOT NULL,
    agencia VARCHAR(10),
    tipo_controle VARCHAR(10), -- O que significa esse atributo?? !!!!!!!!!!!!!
    CONSTRAINT pk_financiador PRIMARY KEY (id_financiador)
);


/*Extensao(PK(nro_extensao), nro_extensao_anterior);*/
--O que essa entidade representa? Uma atividade ou programa de extensão já aprovado
CREATE TABLE Extensao
(
    nro_extensao SERIAL NOT NULL,
    nro_extensao_anterior INT,
    CONSTRAINT pk_extensao PRIMARY KEY (nro_extensao)
);

/*ProgramaDeExtensao(PK(FK_Extensao(nro_extensao)), palavras_chave, titulo, resumo, comunidade_atingida, anotacoes_ProEx, inicio);*/
CREATE TABLE ProgramaDeExtensao
(
    nro_extensao INT NOT NULL,
    palavras_chave VARCHAR(50),
    titulo VARCHAR(30) NOT NULL,
    resumo TEXT,
    comunidade_atingida VARCHAR(50),
    anotacoes_ProEx TEXT,
    inicio DATE,
    
    CONSTRAINT pk_programaDeExtensao PRIMARY KEY (nro_extensao),
    CONSTRAINT fk_programaDeExtensao_extensao FOREIGN KEY (nro_extensao) REFERENCES Extensao(nro_extensao)
);

/*Area(PK(id_area), nome_area);*/
CREATE TABLE Area
(
    id_area SERIAL NOT NULL,
    nome_area VARCHAR(50) NOT NULL,
    CONSTRAINT pk_area PRIMARY KEY (id_area)
);


/*Area_tem_subareas(PK(FK_Area(id_area), id_subarea), nome_area);*/
CREATE TABLE Area_tem_subareas
(
    id_area INT NOT NULL,
    id_subarea INT NOT NULL,
    nome_area VARCHAR(50) NOT NULL,
    CONSTRAINT pk_area_tem_subareas PRIMARY KEY (id_area, id_subarea),
    CONSTRAINT fk_area_tem_subareas_area FOREIGN KEY (id_area) REFERENCES Area(id_area)
);

/*AtividadeDeExtensao(PK(FK_Extensao(nro_extensao)), FK_ProgramaDeExtensao(nro_extensao_pr), FK_Financiador(id_financiador), FK1_Area(id_area_pr), FK2_Area(id_area_se), publico_alvo, palavras_chave, resumo, inicio_real, fim_real, inicio_previsto, fim_previsto, data_aprovacao, tipo_atividade, titulo, status);*/
CREATE TABLE AtividadeDeExtensao
(
    nro_extensao INT NOT NULL,
    nro_extensao_programa INT NOT NULL,
    id_financiador INT,
    id_area_pr INT NOT NULL,
    id_area_se INT NOT NULL,
    publico_alvo VARCHAR(50),
    palavras_chave VARCHAR(50),
    resumo TEXT,
    inicio_real DATE,
    fim_real DATE,
    inicio_previsto DATE,
    fim_previsto DATE,
    data_aprovacao DATE,
    tipo_atividade VARCHAR(20),
    titulo VARCHAR(30),
    status VARCHAR(20),
    
    CONSTRAINT pk_atividadeDeExtensao PRIMARY KEY (nro_extensao),
    CONSTRAINT fk_atividadeDeExtensao_extensao FOREIGN KEY (nro_extensao) REFERENCES Extensao(nro_extensao),
    CONSTRAINT fk_atividadeDeExtensao_programaDeExtensao FOREIGN KEY (nro_extensao_programa) REFERENCES ProgramaDeExtensao(nro_extensao),
    CONSTRAINT fk_atividadeDeExtensao_financiador FOREIGN KEY (id_financiador) REFERENCES Financiador(id_financiador),
    CONSTRAINT fk_atividadeDeExtensao_area1 FOREIGN KEY (id_area_pr) REFERENCES Area(id_area),
    CONSTRAINT fk_atividadeDeExtensao_area2 FOREIGN KEY (id_area_se) REFERENCES Area(id_area)
);

/*Aciepe(PK(FK_AtividadeDeExtensao(nro_extensao)), horario_aulas, ementa, carga_horaria_prevista);*/
CREATE TABLE Aciepe
(
    nro_extensao INT NOT NULL,
    horario_aulas VARCHAR(30),
    ementa TEXT,
    carga_horaria_prevista INT,
    CONSTRAINT pk_Aciepe PRIMARY KEY (nro_extensao),
    CONSTRAINT pk_Aciepe_AtividadeDeExtensao FOREIGN KEY (nro_extensao) REFERENCES AtividadeDeExtensao(nro_extensao)
);

/*Aciepe_Encontros(PK(FK_Aciepe(nro_extensao), data, horario, local, campus));*/
CREATE TABLE Aciepe_Encontros
(
    nro_extensao INT NOT NULL,
    data DATE,
    horario VARCHAR(20),
    local VARCHAR(30),
    campus VARCHAR(15),
    
    CONSTRAINT pk_Aciepe_Encontros PRIMARY KEY (nro_extensao),
    CONSTRAINT fk_Aciepe_Encontros_Aciepe FOREIGN KEY (nro_extensao) REFERENCES Aciepe(nro_extensao)
);

/*Participante(PK(FK_Pessoa(id_pessoa), FK_AtividadeDeExtensao(nro_extensao)), frequencia, avaliacao);*/
CREATE TABLE Participante
(
    id_pessoa INT NOT NULL,
    nro_extensao INT NOT NULL, --O que significa esse atributo? !!!!!!!!
    frequencia INT, --frequencia como sinônimo de faltas
    avaliacao FLOAT CHECK (avaliacao >= 0 and avaliacao <= 10),
    
    CONSTRAINT pk_Participante PRIMARY KEY (id_pessoa, nro_extensao),
    CONSTRAINT fk_Participante_Pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa),
    CONSTRAINT fk_Participante_AtividadeDeExtensao FOREIGN KEY (nro_extensao) REFERENCES AtividadeDeExtensao(nro_extensao)
);


CREATE TABLE Coordenador
(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_ufscar INT UNIQUE NOT NULL,
    
    CONSTRAINT pk_Coordenador PRIMARY KEY (id_pessoa, id_departamento),
    CONSTRAINT fk_Coordenador_Servidor FOREIGN KEY (id_pessoa, id_departamento)
        REFERENCES PessoaServidor (id_pessoa, id_departamento),
    CONSTRAINT fk_Coordenador_Servidor2 FOREIGN KEY (nro_ufscar) REFERENCES PessoaServidor (nro_ufscar)
);

/*Selecao(PK(id_selecao), nro_inscritos, vagas_interno, vagas_externo);*/
CREATE TABLE Selecao
(    
    id_selecao SERIAL NOT NULL,
    nro_inscritos INT,
    vagas_interno INT,
    vagas_externo INT,
    CONSTRAINT pk_Selecao PRIMARY KEY (id_selecao)
);

/*Participante_participa_Selecao(PK(FK_Participante(id_pessoa, nro_extensao), FK_Selecao(id_selecao)), declaracao_presenca, selecionado);*/
CREATE TABLE Participante_participa_Selecao
(
    id_pessoa INT NOT NULL,
    nro_extensao INT NOT NULL,
    id_selecao INT NOT NULL,
    declaracao_presenca VARCHAR(10),
    selecionado BOOLEAN,
    CONSTRAINT pk_Participante_participa_Selecao PRIMARY KEY (id_pessoa, nro_extensao, id_selecao),
    CONSTRAINT fk_Participante_participa_Selecao_Participante FOREIGN KEY (id_pessoa, nro_extensao) REFERENCES Participante(id_pessoa, nro_extensao),
    CONSTRAINT fk_Participante_participa_Selecao_Selecao FOREIGN KEY (id_selecao) REFERENCES Selecao(id_selecao)
);


----------------------------
----------Reunião
----------------------------

CREATE TABLE Reuniao (
    id_reuniao               SERIAL NOT NULL,
    documento_apresentacao    TEXT,
    orgao                    CHAR(4), --caex ou coex
    data_inicio              DATE, -- geração do atributo derivado duração
    data_fim             DATE,
    
    CONSTRAINT PK_Reuniao PRIMARY KEY (id_reuniao)
    
);

CREATE TABLE ReuniaoAta (
    nro_ata     INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_reuniao  INT,
    ata      TEXT,

    CONSTRAINT PK_ReuniaoAta PRIMARY KEY (nro_ata, id_reuniao),
    CONSTRAINT FK_ReuniaoAta
        FOREIGN KEY (id_reuniao) REFERENCES Reuniao(id_reuniao)
);

CREATE TABLE ReuniaoAvalia (
    id_reuniao           INT,
    id_pessoa           INT,
    codigo_edital        INT,
    veredito             TEXT,
    recorrencia          TEXT,

    CONSTRAINT PK_ReuniaoAvalia
     PRIMARY KEY (id_pessoa,id_reuniao,codigo_edital),
     
    CONSTRAINT FK_ReuniaoAvalia_Pessoa
     FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa),

    CONSTRAINT FK_ReuniaoAvalia_Reuniao
     FOREIGN KEY (id_reuniao) REFERENCES Reuniao(id_reuniao),

    CONSTRAINT FK_ReuniaoAvalia_Edital
     FOREIGN KEY (codigo_edital) REFERENCES Edital(codigo)

);

CREATE TABLE ReuniaoParticipa (
    id_reuniao                   INT,
    id_pessoa                    INT,
    data_participacao            DATE,
    presenca                 NUMERIC(1,0) CHECK (presenca=0 OR presenca=1),
    justificativa                TEXT,
    recurso_justificativa        TEXT,
    aprovacao_justificativa     TEXT,

    CONSTRAINT PK_ReuniaoParticipa
     PRIMARY KEY (id_pessoa,id_reuniao),

    CONSTRAINT FK_ReuniaoParticipa_Reuniao
     FOREIGN KEY (id_reuniao) REFERENCES Reuniao(id_reuniao),

    CONSTRAINT FK_ReuniaoParticipa_Pessoa
     FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

CREATE TABLE Demandante(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_ufscar INT NOT NULL,
    data_contratacao DATE,

    CONSTRAINT PK_Demandante PRIMARY KEY (id_pessoa,id_departamento),

    CONSTRAINT FK_PessoaServidor_id_pessoa FOREIGN KEY (id_pessoa, id_departamento) REFERENCES PessoaServidor(id_pessoa, id_departamento)
);

CREATE TABLE Submete(
    codigo_edital INT NOT NULL,
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,

    CONSTRAINT PK_Submete PRIMARY KEY (codigo_edital, id_pessoa, id_departamento),

    CONSTRAINT FK_Edital_codigo FOREIGN KEY (codigo_edital) REFERENCES Edital(codigo),
    CONSTRAINT FK_Demandante_ids FOREIGN KEY (id_pessoa,id_departamento) REFERENCES Demandante(id_pessoa,id_departamento)
);

CREATE TABLE Proposta(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    codigo_edital INT NOT NULL,
    nro_processo INT NOT NULL,
    tipo VARCHAR(20),
    status VARCHAR(20),
    areatematica_grandearea VARCHAR(50),
    areatematica_areasecundaria VARCHAR(50),
    areatematica_areaprincipal VARCHAR(50),
    resumo VARCHAR(50),
    comunidade_atingida VARCHAR(50),
    publico_alvo VARCHAR(50),
    DataFim date,
    DataInicio date NOT NULL,
    descricao VARCHAR(50),
    setor_responsavel VARCHAR(50),
    abrangencia VARCHAR(50),

    CONSTRAINT PK_Proposta PRIMARY KEY (id_pessoa, id_departamento, nro_processo, codigo_edital),

    CONSTRAINT FK_Submete_ids FOREIGN KEY (codigo_edital, id_pessoa, id_departamento) REFERENCES Submete(codigo_edital, id_pessoa, id_departamento)
);

CREATE TABLE Tramitacao (
    id_pessoa INT,
    id_departamento INT,
    codigo_edital INT,
    nro_processo INT,
    nro_extensao INT,
    tipo BOOLEAN, --BOOL, considerando que tipo é o resultado da tramitação
    julgamento TEXT,
    data DATE,

    constraint Tramitacao_pk primary key (id_pessoa, id_departamento, codigo_edital, nro_processo, nro_extensao),
    constraint Tramitacao_proposta_fk foreign key (nro_processo, id_pessoa, id_departamento, codigo_edital)
     references Proposta (nro_processo, id_pessoa, id_departamento, codigo_edital),
    constraint Tramitacao_extensao_fk foreign key (nro_extensao) references Extensao (nro_extensao)
);



CREATE TABLE Avaliador (
    id_pessoa INT,
    id_departamento INT,
    representatividade VARCHAR(20),
    mandatoInicio DATE,
    mandatoFim DATE,

    constraint Avaliador_pk primary key (id_pessoa, id_departamento),
    constraint Avaliador_servidor_fk foreign key (id_pessoa, id_departamento)
     references PessoaServidor (id_pessoa, id_departamento)

);


CREATE TABLE julga (
    id_pessoa        INT,
    codigo_edital     INT,
    Id_reuniao       INT,
    justificativa    TEXT,
    posicionamento    TEXT,
    
    CONSTRAINT PK_Julga PRIMARY KEY (id_pessoa, codigo_edital, Id_reuniao),
    CONSTRAINT FK_id_pessoa_pessoa FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa),
    CONSTRAINT FK_codigo_edital FOREIGN KEY (codigo_edital) REFERENCES edital(codigo),
    CONSTRAINT FK_id_reuniao FOREIGN KEY (id_reuniao) REFERENCES Reuniao(id_reuniao)
);


CREATE TABLE julga_1 (
    id_pessoa        INT,
    id_departamento INT,
    codigo_edital   INT,
    nro_processo    INT,
    Id_reuniao       INT,
    veredito    TEXT,
    recorrencia      TEXT,
    
    CONSTRAINT PK_Julga_1 PRIMARY KEY (id_pessoa, nro_processo, Id_reuniao, id_departamento, codigo_edital),
    CONSTRAINT FK_julga1_proposta FOREIGN KEY (id_pessoa, id_departamento, codigo_edital, nro_processo) 
        REFERENCES Proposta (id_pessoa, id_departamento, codigo_edital, nro_processo),
    CONSTRAINT FK_id_reuniao_1 FOREIGN KEY (Id_reuniao) REFERENCES Reuniao(id_reuniao)
);

CREATE TABLE julga_2 (
    id_pessoa        INT,
    id_departamento INT,
    codigo_edital   INT,
    nro_processo    INT,
    Id_reuniao       INT,
    id_servidor     INT,
    id_dept_servidor INT,
    justificativa    TEXT,
    recorrencia      TEXT,
    
    CONSTRAINT PK_Julga_2 PRIMARY KEY (id_pessoa, nro_processo, Id_reuniao, id_departamento, codigo_edital, id_servidor, id_dept_servidor),
    CONSTRAINT FK_julga2_julga1 FOREIGN KEY (id_pessoa, nro_processo, Id_reuniao, id_departamento, codigo_edital) 
        REFERENCES julga_1 (id_pessoa, nro_processo, Id_reuniao, id_departamento, codigo_edital),
    CONSTRAINT FK_julga2_avaliador FOREIGN KEY (id_servidor, id_dept_servidor) 
        REFERENCES Avaliador (id_pessoa, id_departamento)
);

--

CREATE TABLE Parecer (
    id_pessoa INT,
    id_departamento INT,
    codigo_edital INT,
    nro_processo INT,
    nro_extensao INT,
    num_parecer INT,
    descricao TEXT,

    constraint Parecer_pk primary key (id_pessoa, id_departamento, codigo_edital, nro_processo, nro_extensao, num_parecer),
    constraint Parecer_tramitacao_fk foreign key (nro_processo, id_pessoa, id_departamento, codigo_edital, nro_extensao)
     references Tramitacao (nro_processo, id_pessoa, id_departamento, codigo_edital, nro_extensao)
);


CREATE TABLE Aprovador (
    Numero_UFSCar    INT,
    CONSTRAINT PK_Aprovador PRIMARY KEY (Numero_UFSCar),
    CONSTRAINT FK_Aprovador FOREIGN KEY (Numero_UFSCar) REFERENCES PessoaServidor (nro_ufscar)
);

CREATE TABLE AlteracaoVerba (
    Numero_UFSCar_Apr        INT,
    Numero_UFSCar_Sol        INT,
    Data                     DATE,
    Estado_da_aprovacao      TEXT,
    Valor                    INT,
    Destino                  TEXT,
    Origem                   TEXT,
    CONSTRAINT PK_AlteracaoVerba PRIMARY KEY (Numero_UFSCar_Sol, Numero_UFSCar_Apr, Data),
    CONSTRAINT FK_AlteracaoVerba_Sol FOREIGN KEY (Numero_UFSCar_Sol) REFERENCES Coordenador (nro_ufscar),
    CONSTRAINT FK_AlteracaoVerba_Apr FOREIGN KEY (Numero_UFSCar_Apr) REFERENCES PessoaServidor (nro_ufscar)
);

CREATE TABLE AlteracaoConteudo (
    Numero_UFSCar_Apr        INT,
    Numero_UFSCar_Sol        INT,
    Data                     DATE,
    Estado_da_aprovacao      TEXT,
    Conteudo_substituido    TEXT,
    CONSTRAINT PK_AlteracaoVerbaConteudo PRIMARY KEY (Numero_UFSCar_Sol, Numero_UFSCar_Apr, Data),
    CONSTRAINT FK_AlteracaoVerba_Sol2 FOREIGN KEY (Numero_UFSCar_Sol) REFERENCES Coordenador (nro_ufscar), 
    CONSTRAINT FK_AlteracaoVerba_Apr2 FOREIGN KEY (Numero_UFSCar_Apr) REFERENCES PessoaServidor (nro_ufscar)
);

--drop table AlteracaoIntegrante
CREATE TABLE AlteracaoIntegrante (
    Numero_UFSCar_Apr        INT,
    Numero_UFSCar_Sol        INT,
    Data                     DATE,
    Estado_da_aprovacao      TEXT,
    Status                   TEXT,
    CONSTRAINT PK_AlteracaoVerbaIntegrante PRIMARY KEY (Numero_UFSCar_Sol, Numero_UFSCar_Apr, Data),
    CONSTRAINT FK_AlteracaoVerba_Sol3 FOREIGN KEY (Numero_UFSCar_Sol) REFERENCES Coordenador (nro_ufscar),
    CONSTRAINT FK_AlteracaoVerba_Apr3 FOREIGN KEY (Numero_UFSCar_Apr) REFERENCES PessoaServidor (nro_ufscar)
);

--


CREATE TABLE SetoresParticipantes(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_processo INT    NOT NULL,
    codigo_edital INT NOT NULL,
    setores VARCHAR(50),

    CONSTRAINT PK_SetoresParticipantes PRIMARY KEY (id_pessoa, id_departamento, nro_processo, codigo_edital),
    CONSTRAINT FK_Proposta_ids1 FOREIGN KEY (id_pessoa, id_departamento, nro_processo, codigo_edital) 
        REFERENCES Proposta(id_pessoa, id_departamento, nro_processo, codigo_edital)
);

CREATE TABLE Parcerias(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_processo INT    NOT NULL,
    codigo_edital INT NOT NULL,
    setores VARCHAR(50),

    CONSTRAINT PK_Parcerias PRIMARY KEY (id_pessoa, id_departamento, nro_processo, codigo_edital),
    CONSTRAINT FK_Proposta_ids2 FOREIGN KEY (id_pessoa, id_departamento, nro_processo, codigo_edital) 
        REFERENCES Proposta(id_pessoa, id_departamento, nro_processo, codigo_edital)
);

CREATE TABLE PalavrasChave(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_processo INT    NOT NULL,
    codigo_edital INT NOT NULL,
    palavras VARCHAR(50),

    CONSTRAINT PK_PalavrasChave PRIMARY KEY (id_pessoa, id_departamento, nro_processo, codigo_edital),

    CONSTRAINT FK_Proposta_ids3 FOREIGN KEY (id_pessoa, id_departamento, nro_processo, codigo_edital) 
        REFERENCES Proposta(id_pessoa, id_departamento, nro_processo, codigo_edital)
);

CREATE TABLE LinhaProgramatica(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_processo INT    NOT NULL,
    codigo_edital INT NOT NULL,
    data1 DATE,
    horario TIMESTAMP,
    atividade VARCHAR(50),

    CONSTRAINT PK_LinhaProgramatica PRIMARY KEY (id_pessoa, id_departamento, nro_processo, codigo_edital),

    CONSTRAINT FK_Proposta_ids4 FOREIGN KEY (id_pessoa, id_departamento, nro_processo, codigo_edital) 
        REFERENCES Proposta(id_pessoa, id_departamento, nro_processo, codigo_edital)
);

CREATE TABLE Anotacoes(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_processo INT    NOT NULL,
    codigo_edital INT NOT NULL,
    anotacoes VARCHAR(200),

    CONSTRAINT PK_Anotacoes PRIMARY KEY (id_pessoa, id_departamento, nro_processo, codigo_edital),

    CONSTRAINT FK_Proposta_ids5 FOREIGN KEY (id_pessoa, id_departamento, nro_processo, codigo_edital) 
        REFERENCES Proposta(id_pessoa, id_departamento, nro_processo, codigo_edital)
);

CREATE TABLE Errata
(
    CodigoEdital INT NOT NULL,
    Conteudo VARCHAR(4000),
    CONSTRAINT pk_Errata PRIMARY KEY (CodigoEdital, Conteudo),
    CONSTRAINT fk_Errata FOREIGN KEY (CodigoEdital) REFERENCES edital(codigo) 
);

CREATE TABLE CoordenadorCoordenaAtividade
(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_extensao INT NOT NULL,
    InicioCoordenacao DATE,
    FimCoordenacao DATE,
    Cargo VARCHAR(30),
    CONSTRAINT pk_CoordenadorCoordenaAtividade PRIMARY KEY (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, Cargo),
    CONSTRAINT fk_CoordenadorCoordenaAtividade_Coord FOREIGN KEY (id_pessoa, id_departamento) REFERENCES Coordenador(id_pessoa, id_departamento),
    CONSTRAINT fk_CoordenadorCoordenaAtividade_Ativ FOREIGN KEY (nro_extensao) REFERENCES AtividadeDeExtensao(nro_extensao)
);

CREATE TABLE CoordenadorViceCoordenaAtividade(
    id_pessoa INT NOT NULL,
    id_departamento INT NOT NULL,
    nro_extensao INT NOT NULL,
    InicioCoordenacao DATE NOT NULL,
    FimCoordenacao DATE,

    CONSTRAINT pk_coordenadorViceCoordenaAtividade PRIMARY KEY (id_pessoa, id_departamento, nro_extensao),
    CONSTRAINT fk_coordenadorViceCoordenaAtividade_coordenador FOREIGN KEY (id_pessoa, id_departamento) REFERENCES Coordenador (id_pessoa, id_departamento),
    CONSTRAINT fk_coordenadorViceCoordenaAtividade_atividadeDeExtensao FOREIGN KEY (nro_extensao) REFERENCES AtividadeDeExtensao (nro_extensao)
);

CREATE TABLE Financia
(
	id_financia INT NOT NULL,
	nro_financiador INT NOT NULL,
	valor INT,
	nro_atividadeDeExtensao INT,
	
	CONSTRAINT pk_Financia PRIMARY KEY (id_financia, nro_atividadeDeExtensao),
	CONSTRAINT fk_Financiador_nroFinanciador FOREIGN KEY (nro_financiador) REFERENCES financiador(id_financiador),
	CONSTRAINT fk_Financiador_AtividadeDeExtensao FOREIGN KEY (nro_atividadeDeExtensao) REFERENCES AtividadeDeExtensao(nro_extensao)
);

CREATE OR REPLACE VIEW vEditais_com_detalhes AS 
    SELECT data_abertura, data_encerramento, tipo, titulo, proponente, objetivo, bolsa, atividade, data, disposicao, e.codigo as id_edital
    FROM edital e,  proponente p, objetivo o, bolsa b, cronograma c, disposicoes_gerais d
	WHERE e.codigo = p.codigo_edital and e.codigo = o.codigo_edital and e.codigo = b.codigo_edital and e.codigo = c.codigo_edital and e.codigo = d.codigo_edital;

CREATE OR REPLACE VIEW vEditais_Abertos AS 
	SELECT codigo, titulo, tipo, justificativa, (data_encerramento - data_abertura) AS tempo_restante 
	FROM edital 
	WHERE data_abertura <= current_date AND data_encerramento > current_date;
    
CREATE OR REPLACE VIEW vEditais_Fechados AS 
	SELECT codigo, titulo, tipo, justificativa, data_encerramento   
	FROM edital 
	WHERE data_encerramento <= current_date;

CREATE VIEW vCpfPassaporte AS 
    SELECT P.id_pessoa, concat(PB.cpf, PE.passaporte) AS CpfOuPass, P.nome
    FROM Pessoa AS P LEFT JOIN PessoaBrasileira AS PB on P.id_pessoa = PB.id_pessoa
        LEFT JOIN PessoaEstrangeira AS PE on P.id_pessoa = PE.id_pessoa
    ORDER BY P.id_pessoa;

/*
vAtividades
VIEW com Atividades (DADOS: codigo, tipo, titulo, resumo, status, nome do coordenador, cargo (docente adjunto, etc))
    O campus não foi mostrado pois por algum motivo essa informação só existe para aciepes.
    Esta view mostra todas as atividades de extensão, sejam elas não iniciadas, em andamento ou finalizadas.
    Para as atividades em andamento ou finalizadas que tiveram mais de um coordenador ao longo do tempo, o último é exibido.
    Ordenada pelo número da atividade de extensão 
*/
CREATE VIEW vAtividades AS 
    SELECT A.nro_extensao, A.tipo_atividade, A.titulo, A.resumo, A.status, P.nome AS coordenador, concat(PSC.cargo, ' ', PSC.tipo) AS cargoETipo
    FROM AtividadeDeExtensao AS A LEFT JOIN CoordenadorCoordenaAtividade AS CCA ON A.nro_extensao = CCA.nro_extensao
        LEFT JOIN Pessoa AS P ON CCA.id_pessoa = P.id_pessoa
        LEFT JOIN PessoaServidorDocente PSC on P.id_pessoa = PSC.id_pessoa
    WHERE CCA.FimCoordenacao IS null OR A.fim_real = CCA.FimCoordenacao
    ORDER BY A.nro_extensao;

---------------------------------- TRIGGERS ----------------------------------


--------------------------------- FUNCTIONS ---------------------------------

/*
VerificaCpfPass
--- FUNCTION que verifica se o cpf ou passaporte já está cadastrado ---
    @PassOuCpf = Passaporte ou cpf a ser consultado (VARCHAR);
    retorno 1 = Passaporte/Cpf já cadastrado;
    retorno 0 = Passaporte/Cpf não está cadastrado;
*/
CREATE FUNCTION VerificaCpfPass (PassOuCpf IN VARCHAR)
RETURNS INTEGER AS $$
DECLARE
	c_busca CURSOR (PassOuCpf VARCHAR) IS SELECT CpfOuPass FROM vCpfPassaporte WHERE CpfOuPass = PassOuCpf;
	v_busca VARCHAR;
	ret INTEGER;
BEGIN
	OPEN c_busca(PassOuCpf);
	FETCH c_busca INTO v_busca;
	IF FOUND THEN
		ret := 1;
	ELSE
		ret := 0;
	END IF;
	
	CLOSE c_busca;
	RETURN ret;
END;
$$ LANGUAGE plpgsql;

/*
VerificaInscricao
--- FUNCTION que verifica se a pessoa já está inscrita na atividade especificada---
    @pid_pessoa = id da pessoa (INTEGER);
    @pid_atividade = número da atividade de extensao (INTEGER);
    retorno 1 = Pessoa já inscrita na atividade;
    retorno 0 = Pessoa não está inscrita na atividade;
*/
CREATE FUNCTION VerificaInscricao (pid_pessoa IN INTEGER, pid_atividade IN INTEGER)
RETURNS INTEGER AS $$
DECLARE
	c_busca CURSOR (pid_pessoa INTEGER, pid_atividade INTEGER) IS SELECT id_pessoa FROM Participante WHERE id_pessoa = pid_pessoa AND nro_extensao = pid_atividade;
	v_busca INTEGER;
	ret INTEGER;
BEGIN
	OPEN c_busca(pid_pessoa, pid_atividade);
	FETCH c_busca INTO v_busca;
	IF FOUND THEN
		ret := 1;
	ELSE
		ret := 0;
	END IF;
	
	CLOSE c_busca;
	RETURN ret;
END;
$$ LANGUAGE plpgsql;
	

CREATE OR REPLACE VIEW vizualizaVerbas AS
	SELECT AtividadeDeExtensao.titulo, AlteracaoVerba.Data, AlteracaoVerba.Valor, AlteracaoVerba.Destino, AlteracaoVerba.Origem
		FROM AtividadeDeExtensao, AlteracaoVerba, Coordenador, CoordenadorCoordenaAtividade
		WHERE AtividadeDeExtensao.nro_extensao = CoordenadorCoordenaAtividade.nro_extensao AND Coordenador.id_pessoa = CoordenadorCoordenaAtividade.id_pessoa AND Coordenador.id_departamento = CoordenadorCoordenaAtividade.id_departamento AND Coordenador.nro_ufscar = AlteracaoVerba.Numero_UFSCar_Sol;

CREATE OR REPLACE FUNCTION CalculaTempoCoordenacao (nome_coordenador IN VARCHAR, titulo_atividade IN VARCHAR)
	RETURNS DATE AS $$
DECLARE
	v_nro_extensao CoordenadorCoordenaAtividade.nro_extensao%type;
	v_data_inicio CoordenadorCoordenaAtividade.InicioCoordenacao%type;
	v_data_fim CoordenadorCoordenaAtividade.FimCoordenacao%type;
BEGIN
	select Pessoa.nome, CoordenadorCoordenaAtividade.InicioCoordenacao, CoordenadorCoordenaAtividade.FimCoordenacao
		INTO v_data_inicio, v_data_fim
		FROM CoordenadorCoordenaAtividade
		WHERE Pessoa.nome = nome_coordenador AND Pessoa.id_pessoa = CoordenadorCoordena.id_pessoa AND CoordenadorCoordena.nro_extensao = AtividadeDeExtensao.nro_extensao AND
		Departamento.nome = nome_departamento AND Departamento.id_departamento = CoordenadorCoordena.id_departamento;
	RETURN v_data_fim - v_data_inicio;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW get_all_participantes_in_atividades AS
	SELECT pessoa.nome, pessoa.id_pessoa, AtividadeDeExtensao.nro_extensao AS nro_extensao
		FROM pessoa, participante, AtividadeDeExtensao
		WHERE AtividadeDeExtensao.nro_extensao = participante.nro_extensao AND participante.nro_extensao = pessoa.id_pessoa;

CREATE OR REPLACE VIEW get_dados_from_atividade AS
	SELECT AtividadeDeExtensao.resumo, AtividadeDeExtensao.tipo_atividade, AtividadeDeExtensao.titulo, AtividadeDeExtensao.status, programadeExtensao.anotacoes_proex
		FROM AtividadeDeExtensao, programadeExtensao
		WHERE AtividadeDeExtensao.nro_extensao_programa = programadeExtensao.nro_extensao;


CREATE OR REPLACE FUNCTION sum_verba_atividade
(atividade IN INT)
RETURNS FLOAT AS $$
DECLARE
	cnumber FLOAT;
	valores cursor FOR SELECT SUM(financia.valor)
							FROM financia, ATIVIDADEDEEXTENSAO
							WHERE ATIVIDADEDEEXTENSAO.nro_extensao = atividade AND financia.nro_atividadeDeExtensao = ATIVIDADEDEEXTENSAO.nro_extensao;
BEGIN
	open valores;
	fetch valores into cnumber;
	Return cnumber;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW listar_atividades_extensao AS 
	SELECT atividade.nro_extensao_programa,id_financiador,id_area_pr,id_area_se,publico_alvo,palavras_chave,resumo,inicio_real,fim_real,inicio_previsto,fim_previsto,data_aprovacao,tipo_atividade,titulo,status, id_pessoa, id_departamento
		FROM AtividadeDeExtensao atividade, CoordenadorCoordenaAtividade coordena WHERE atividade.nro_extensao = coordena.nro_extensao;

CREATE OR REPLACE FUNCTION calcular_carga_horaria_prevista(nro IN INT)
		RETURNS INT AS $$
	DECLARE
		calculo CURSOR FOR SELECT fim_previsto - inicio_previsto AS carga_horaria FROM AtividadeDeExtensao WHERE nro_extensao = nro;
		carga_horaria INT;
	BEGIN
		open calculo;

		if calculo%notfound then
			RAISE EXCEPTION 'atividade nao encontrada';
		end if;

		FETCH calculo INTO carga_horaria;

		CLOSE calculo;

		RETURN carga_horaria;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE logar (cpf IN CHAR, passaporte IN CHAR, id_pessoa INOUT INT)
	AS $$
	DECLARE
		buscaCPF CURSOR FOR SELECT id_pessoa FROM PessoaBrasileira pessoa WHERE pessoa.cpf = cpf;
		buscaPAS CURSOR FOR SELECT id_pessoa FROM PessoaEstrangeira pessoa WHERE pessoa.passaporte = passaporte;

	BEGIN
		if cpf != NULL then
			OPEN buscaCPF;
			FETCH buscaCPF INTO id_pessoa;
			CLOSE buscaCPF;
		else
			OPEN buscaPAS;
			FETCH buscaPAS INTO id_pessoa;
			CLOSE buscaPAS; 
		end if;
END;
$$ LANGUAGE plpgsql;


insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Eduardo', 'minha senha', 'PA', 'Belem', 'Nazare', 'Nazare', 1234);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Gustavo', 'senhafacil', 'SP', 'São Carlos', 'Jardins', 'Oliveira', 125);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Fernando', 'pipopi', 'SP', 'São Jose dos Campos', 'Argentina', 'Rua 15', 365);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Jonatan', '12345', 'SP', 'São Paulo', 'Zona Lost', 'Paulista', 1564);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Carlos', '951753', 'SP', 'São Carlos', 'Planalto paraiso', 'Robson Luiz', 1489);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Vitor', 'mlpoki', 'SP', 'Campinas', 'Papoula', 'Rua das Luzes', 1597);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Alisson', 'senhadodc', 'SP', 'São Carlos', 'Jardins', 'Rosa', 134);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Amanda', 'senhapratudo', 'SP', 'São Carlos', 'Jardins', 'Tulipa', 234);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Fernanda', 'poiklnm', 'SP', 'São Carlos', 'Centro', 'Padre Teixeira', 1398);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Maria', 'poiuytghjkl', 'SP', 'Ribeirão Preto', 'Centro', 'Rua 9 de Julho', 1234);
insert into pessoa(nome, senha, uf, cidade, bairro, rua, numero) values ('Luis', '12345678', 'SP', 'Limeira', 'Vila', 'Rua 1 de Agosto', 250);


insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) 
values ('2019-05-18', '2020-11-18', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Blue', 'Varanus albigularis', false);

insert into proponente(codigo_edital, proponente) values (1, 'Carlos');
insert into proponente(codigo_edital, proponente) values (1, 'Jonathan');
insert into proponente(codigo_edital, proponente) values (1, 'Vitor');

insert into objetivo(codigo_edital, objetivo) values (1, 'Carlos');
insert into objetivo(codigo_edital, objetivo) values (1, 'Jonathan');
insert into objetivo(codigo_edital, objetivo) values (1, 'Vitor');

insert into cronograma(codigo_edital, atividade, data) values (1, 'Fazer o pipipi', '2019-05-18');
insert into cronograma(codigo_edital, atividade, data) values (1, 'Fazer o popopo', '2019-05-18');
insert into cronograma(codigo_edital, atividade, data) values (1, 'Fazer o pipipi popop', '2019-05-18');

insert into disposicoes_gerais(codigo_edital, disposicao) values (1, 'Fulaninho faz o pipipi');
insert into disposicoes_gerais(codigo_edital, disposicao) values (1, 'Fulanoso faz o popopo');
insert into disposicoes_gerais(codigo_edital, disposicao) values (1, 'Fulaníssimo faz o pipipi popopo');



insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-05-18', '2020-11-18', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Blue', 'Varanus albigularis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-12', '2020-04-12', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Crimson', 'Psittacula krameri', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-10-17', '2017-04-17', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 'Fuscia', 'Crocodylus niloticus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-04-28', '2020-04-28', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Blue', 'Eolophus roseicapillus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-23', '2021-03-23', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Violet', 'unavailable', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-10-27', '2016-04-27', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Turquoise', 'Sylvicapra grimma', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-28', '2021-04-28', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Orange', 'Junonia genoveua', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-09-10', '2019-09-10', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Maroon', 'Coluber constrictor', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-27', '2019-02-27', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Puce', 'Chauna torquata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-12-29', '2021-06-29', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Turquoise', 'Actophilornis africanus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-11', '2020-02-11', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Violet', 'Agkistrodon piscivorus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-06', '2020-08-06', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Crimson', 'Anas bahamensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-28', '2019-04-28', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Turquoise', 'Gopherus agassizii', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-03', '2021-08-03', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Fuscia', 'Phalaropus lobatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-10-08', '2021-10-08', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Fuscia', 'Haematopus ater', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-22', '2019-06-22', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Fuscia', 'Eubalaena australis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-02', '2022-08-02', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Fuscia', 'Coluber constrictor', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-01-13', '2017-07-13', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Puce', 'Boa constrictor mexicana', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-06', '2021-11-06', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Yellow', 'Cebus apella', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-10', '2019-10-10', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Maroon', 'Aegypius tracheliotus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-24', '2017-09-24', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Puce', 'Delphinus delphis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-22', '2016-12-22', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Puce', 'Chlamydosaurus kingii', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-06-01', '2019-12-01', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 'Crimson', 'Pteropus rufus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-14', '2021-04-14', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Pink', 'Phoca vitulina', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-03-09', '2022-09-09', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Fuscia', 'Theropithecus gelada', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-05-10', '2017-05-10', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Aquamarine', 'Salvadora hexalepis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-07-13', '2020-01-13', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Purple', 'Connochaetus taurinus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-03-31', '2020-09-30', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Puce', 'Sciurus niger', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-06', '2021-11-06', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Khaki', 'Rhea americana', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-01-09', '2020-01-09', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Goldenrod', 'Rangifer tarandus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-14', '2019-07-14', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Green', 'Butorides striatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-20', '2022-09-20', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Blue', 'Zosterops pallidus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-19', '2020-08-19', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 'Turquoise', 'Ceratotherium simum', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-11-08', '2019-05-08', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Yellow', 'Nasua nasua', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-10', '2021-01-10', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Blue', 'Charadrius tricollaris', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-10', '2018-02-10', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Green', 'Macropus robustus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-30', '2021-10-30', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Indigo', 'Aegypius tracheliotus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-09-21', '2017-03-21', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Goldenrod', 'Alouatta seniculus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-21', '2021-02-21', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Yellow', 'Alligator mississippiensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-22', '2022-02-22', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Green', 'Otaria flavescens', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-07-18', '2019-07-18', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Maroon', 'Ctenophorus ornatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-06-15', '2019-12-15', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Maroon', 'Hyaena hyaena', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-16', '2018-05-16', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Teal', 'Zosterops pallidus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-05-24', '2017-11-24', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Mauv', 'Dendrocitta vagabunda', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-27', '2020-05-27', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Puce', 'Aegypius tracheliotus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-07-07', '2018-07-07', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Puce', 'Felis silvestris lybica', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-06-16', '2022-06-16', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Green', 'Perameles nasuta', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-06-08', '2018-12-08', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Green', 'Isoodon obesulus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-06-07', '2021-12-07', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Goldenrod', 'Vanellus chilensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-08', '2019-07-08', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Orange', 'Ovis ammon', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-26', '2020-05-26', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Maroon', 'Vanellus armatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-10-27', '2019-04-27', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Blue', 'Leptoptilos crumeniferus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-04-18', '2019-10-18', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 'Goldenrod', 'Dipodomys deserti', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-09', '2021-09-09', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Fuscia', 'Ardea golieth', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-11-24', '2016-11-24', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Teal', 'Felis libyca', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-06', '2019-01-06', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Teal', 'Plocepasser mahali', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-03-15', '2021-09-15', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Orange', 'Tiliqua scincoides', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-28', '2021-11-28', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Puce', 'Eudyptula minor', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-08-05', '2020-08-05', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Crimson', 'Tyto novaehollandiae', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-06-15', '2023-06-15', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Pink', 'Butorides striatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-24', '2016-12-24', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Mauv', 'Fratercula corniculata', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-09-17', '2020-09-17', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Pink', 'Paraxerus cepapi', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-05-25', '2017-11-25', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Green', 'Castor canadensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-30', '2022-10-30', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'Crimson', 'Hymenolaimus malacorhynchus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-24', '2021-11-24', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Yellow', 'Merops bullockoides', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-11-13', '2022-05-13', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Indigo', 'Hymenolaimus malacorhynchus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-06-06', '2020-06-06', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Aquamarine', 'Ploceus rubiginosus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-10-06', '2018-04-06', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Crimson', 'Larus sp.', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-08-14', '2020-08-14', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 'Goldenrod', 'Ovis ammon', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-12', '2019-08-12', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Violet', 'Cathartes aura', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-11-16', '2019-05-16', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Maroon', 'Caiman crocodilus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-06-27', '2020-06-27', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Red', 'Ardea golieth', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-05', '2022-01-05', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Turquoise', 'Paroaria gularis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-06', '2021-11-06', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Purple', 'Uraeginthus granatina', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-10-24', '2017-10-24', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Aquamarine', 'Cyrtodactylus louisiadensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-22', '2021-03-22', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Orange', 'Fregata magnificans', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-03-03', '2021-03-03', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Crimson', 'Alligator mississippiensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-03-13', '2016-09-13', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Turquoise', 'Colaptes campestroides', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-07-03', '2018-07-03', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Blue', 'Priodontes maximus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-07-23', '2020-01-23', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Violet', 'Zonotrichia capensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-01-19', '2017-07-19', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Green', 'Varanus albigularis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-06-20', '2022-06-20', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Blue', 'Connochaetus taurinus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-01-22', '2021-01-22', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Crimson', 'Hystrix cristata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-07-19', '2019-07-19', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Mauv', 'Phascogale tapoatafa', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-05', '2021-01-05', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Aquamarine', 'Castor canadensis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-09-01', '2019-03-01', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Blue', 'Paradoxurus hermaphroditus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-07-31', '2021-07-31', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Aquamarine', 'Conolophus subcristatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-10-05', '2019-04-05', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Green', 'Canis lupus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-08', '2022-08-08', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Mauv', 'Otocyon megalotis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-11-16', '2022-05-16', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Crimson', 'Fregata magnificans', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-01-05', '2021-07-05', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Puce', 'Capreolus capreolus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-10-10', '2020-10-10', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Mauv', 'Paradoxurus hermaphroditus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-22', '2022-08-22', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Yellow', 'Balearica pavonina', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-23', '2018-03-23', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Khaki', 'Funambulus pennati', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-03-16', '2018-09-16', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Yellow', 'Certotrichas paena', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-06-08', '2019-06-08', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Fuscia', 'Spermophilus lateralis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-05-08', '2022-11-08', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'Khaki', 'Acinynox jubatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-10', '2017-08-10', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Red', 'Phoenicopterus chilensis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-24', '2019-05-24', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Yellow', 'Gyps bengalensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-06-22', '2019-12-22', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Crimson', 'Haliaeetus leucoryphus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-11-07', '2017-05-07', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'Orange', 'Connochaetus taurinus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-01-11', '2019-01-11', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Yellow', 'Falco peregrinus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-10-10', '2020-04-10', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Yellow', 'Aegypius occipitalis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-21', '2018-11-21', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Crimson', 'Phoeniconaias minor', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-11-30', '2018-05-30', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Aquamarine', 'Helogale undulata', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-25', '2017-06-25', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Turquoise', 'Hyaena brunnea', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-09-18', '2016-09-18', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Puce', 'Chelodina longicollis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-06-07', '2019-12-07', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Puce', 'Acrobates pygmaeus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-12-12', '2020-06-12', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Mauv', 'Damaliscus dorcas', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-19', '2020-11-19', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Pink', 'Lama pacos', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-21', '2017-07-21', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Red', 'Ictonyx striatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-15', '2017-06-15', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Goldenrod', 'Sciurus vulgaris', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-19', '2018-07-19', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Fuscia', 'Spilogale gracilis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-03-16', '2022-09-16', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Yellow', 'Butorides striatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-08', '2019-03-08', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.', 'Fuscia', 'Lepus arcticus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-09-19', '2019-09-19', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Khaki', 'Oreamnos americanus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-09-10', '2020-09-10', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Violet', 'Uraeginthus bengalus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-20', '2018-08-20', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Fuscia', 'Uraeginthus angolensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-03-26', '2017-03-26', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Goldenrod', 'Thalasseus maximus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-01', '2018-02-01', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Puce', 'Sus scrofa', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-07-24', '2021-07-24', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Blue', 'Castor canadensis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-06-13', '2021-12-13', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Crimson', 'Nannopterum harrisi', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-01', '2020-05-01', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Purple', 'Merops nubicus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-03-02', '2021-03-02', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Red', 'Cyrtodactylus louisiadensis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-05', '2019-06-05', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Red', 'Lasiodora parahybana', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-06', '2019-09-06', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 'Fuscia', 'Ornithorhynchus anatinus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-30', '2020-04-30', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Green', 'Zenaida galapagoensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-16', '2021-10-16', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Violet', 'Butorides striatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-07-22', '2020-01-22', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'Mauv', 'Bubalus arnee', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-10-23', '2017-10-23', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Crimson', 'Paroaria gularis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-09-29', '2019-03-29', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Orange', 'Gorilla gorilla', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-06-29', '2021-06-29', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Maroon', 'Psophia viridis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-09-16', '2018-09-16', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Crimson', 'Carduelis pinus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-08', '2017-08-08', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Yellow', 'Ovibos moschatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-31', '2019-02-28', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Mauv', 'Oncorhynchus nerka', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-04-11', '2018-10-11', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Mauv', 'Pseudocheirus peregrinus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-25', '2021-10-25', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Mauv', 'Tetracerus quadricornis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-06-16', '2018-06-16', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Puce', 'Balearica pavonina', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-11-08', '2020-11-08', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Blue', 'Papilio canadensis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-11-03', '2019-11-03', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Indigo', 'Butorides striatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-02', '2021-02-02', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Fuscia', 'Phalacrocorax brasilianus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-11-05', '2016-11-05', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Teal', 'Myiarchus tuberculifer', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-02', '2019-01-02', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'Aquamarine', 'Vulpes chama', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-14', '2021-04-14', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Teal', 'Pseudoleistes virescens', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-01-08', '2022-07-08', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Blue', 'Nyctanassa violacea', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-03-30', '2020-03-30', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Teal', 'Larus sp.', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-03-23', '2019-09-23', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Pink', 'Hystrix cristata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-04-18', '2019-04-18', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Indigo', 'Nucifraga columbiana', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-08-28', '2020-08-28', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Red', 'Ninox superciliaris', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-07', '2021-03-07', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Yellow', 'unavailable', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-01-09', '2017-01-09', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Maroon', 'Equus burchelli', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-15', '2023-02-15', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Green', 'Pedetes capensis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-18', '2019-03-18', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Pink', 'Haliaetus vocifer', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-07-03', '2017-01-03', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Mauv', 'Ciconia ciconia', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-09-17', '2017-03-17', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Pink', 'Anas bahamensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-05-30', '2017-11-30', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'Blue', 'Pycnonotus nigricans', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-04-09', '2017-10-09', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Yellow', 'Ara ararauna', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-12-08', '2019-12-08', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Mauv', 'Eutamias minimus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-12-09', '2022-06-09', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Aquamarine', 'Phalacrocorax niger', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-06-01', '2018-06-01', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Pink', 'Felis silvestris lybica', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-11-07', '2018-05-07', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'Turquoise', 'Procyon cancrivorus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-10-19', '2019-10-19', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Puce', 'Tayassu tajacu', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-04-30', '2017-10-30', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Indigo', 'Procyon cancrivorus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-15', '2018-11-15', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Yellow', 'Funambulus pennati', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-25', '2019-07-25', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Pink', 'Cacatua tenuirostris', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-09-03', '2017-09-03', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Turquoise', 'Papilio canadensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-29', '2019-06-29', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Purple', 'Rhea americana', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-04-03', '2016-10-03', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Teal', 'Manouria emys', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-10', '2019-07-10', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Orange', 'Phalacrocorax carbo', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-31', '2018-07-31', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Purple', 'Oryx gazella', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-17', '2020-11-17', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Yellow', 'Phalacrocorax albiventer', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-04-30', '2020-10-30', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Khaki', 'Tadorna tadorna', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-18', '2020-03-18', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Orange', 'Seiurus aurocapillus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-30', '2016-12-30', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Pink', 'Ovis orientalis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-06-14', '2019-12-14', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Yellow', 'Cynictis penicillata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-10-24', '2021-10-24', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Fuscia', 'Meles meles', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-05-09', '2021-11-09', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Goldenrod', 'Neophron percnopterus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-06', '2019-10-06', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Mauv', 'Larus fuliginosus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-08', '2019-05-08', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Green', 'Tiliqua scincoides', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-01', '2022-05-01', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Pink', 'Bettongia penicillata', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-24', '2020-07-24', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Mauv', 'Neophoca cinerea', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-04-11', '2019-04-11', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Mauv', 'Mungos mungo', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-27', '2021-04-27', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Red', 'Ara chloroptera', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-07-19', '2020-07-19', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Turquoise', 'Anthropoides paradisea', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-17', '2022-02-17', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'Red', 'Macropus parryi', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-05-21', '2019-05-21', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Blue', 'Pseudocheirus peregrinus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-12-20', '2019-06-20', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Green', 'Sarkidornis melanotos', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-09-18', '2017-03-18', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Yellow', 'Tamiasciurus hudsonicus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-07-08', '2023-01-08', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Mauv', 'Ovibos moschatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-12-16', '2020-12-16', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Puce', 'Pseudalopex gymnocercus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-04-22', '2019-10-22', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Maroon', 'Larus fuliginosus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-09', '2020-08-09', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Red', 'Conolophus subcristatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-04-27', '2018-10-27', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Goldenrod', 'Cervus elaphus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-08', '2021-02-08', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Blue', 'Trichechus inunguis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-19', '2020-02-19', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Purple', 'Ictalurus furcatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-08-23', '2020-08-23', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Blue', 'Bettongia penicillata', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-03-10', '2019-09-10', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Goldenrod', 'Pavo cristatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-03-29', '2019-09-29', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Khaki', 'Eunectes sp.', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-04-15', '2016-10-15', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Teal', 'Lama glama', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-06-19', '2019-06-19', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Indigo', 'Delphinus delphis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-09', '2020-03-09', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Khaki', 'Cervus duvauceli', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-29', '2021-02-28', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Goldenrod', 'Coluber constrictor foxii', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-04-14', '2020-04-14', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Yellow', 'Microcavia australis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-22', '2016-08-22', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Yellow', 'Balearica pavonina', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-01-17', '2023-01-17', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Purple', 'Procyon lotor', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-19', '2020-05-19', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Violet', 'unavailable', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-10-09', '2021-10-09', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Teal', 'Equus burchelli', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-02-12', '2019-02-12', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'Purple', 'Alopochen aegyptiacus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-18', '2022-09-18', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'Violet', 'Dasypus septemcincus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-07-21', '2021-01-21', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Maroon', 'Streptopelia senegalensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-12-09', '2020-06-09', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Violet', 'Bos taurus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-03-22', '2020-09-22', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Blue', 'Cynomys ludovicianus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-06', '2018-07-06', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Teal', 'Pavo cristatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-11-22', '2020-05-22', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Orange', 'Felis caracal', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-27', '2017-02-27', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Yellow', 'Coluber constrictor', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-07-26', '2017-01-26', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Purple', 'Arctogalidia trivirgata', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-12-29', '2017-06-29', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Orange', 'Panthera leo', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-05-11', '2017-05-11', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Aquamarine', 'Lorythaixoides concolor', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-10', '2019-08-10', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Orange', 'Oxybelis fulgidus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-21', '2021-03-21', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Indigo', 'Gyps bengalensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-07-07', '2022-01-07', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Violet', 'Ovis canadensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-12-28', '2019-06-28', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Maroon', 'Bucorvus leadbeateri', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2015-09-07', '2016-03-07', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Green', 'Semnopithecus entellus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-06-15', '2022-06-15', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Orange', 'Psophia viridis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-05-20', '2018-11-20', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Red', 'Corvus brachyrhynchos', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-03', '2021-02-03', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Crimson', 'Isoodon obesulus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-05', '2022-10-05', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Pink', 'Alectura lathami', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-05-29', '2018-05-29', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Orange', 'Myiarchus tuberculifer', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-08', '2020-11-08', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Blue', 'Colobus guerza', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-10-16', '2020-04-16', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Khaki', 'Bettongia penicillata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-05-18', '2019-11-18', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Orange', 'Theropithecus gelada', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-12-15', '2022-06-15', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'Yellow', 'Cacatua galerita', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-12-30', '2022-12-30', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Yellow', 'Centrocercus urophasianus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-09-18', '2019-03-18', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Mauv', 'Gerbillus sp.', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-01-21', '2019-07-21', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Khaki', 'Boa caninus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-06-02', '2019-06-02', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Maroon', 'Buteo jamaicensis', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-07', '2021-01-07', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Turquoise', 'Nycticorax nycticorax', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-06-28', '2020-06-28', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Crimson', 'Dipodomys deserti', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-12-30', '2017-06-30', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'Aquamarine', 'Acrantophis madagascariensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-11-22', '2020-05-22', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Crimson', 'Antechinus flavipes', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-06', '2021-08-06', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Indigo', 'Leipoa ocellata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-01-11', '2020-07-11', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'Red', 'Fregata magnificans', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-13', '2019-01-13', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Fuscia', 'Pseudoleistes virescens', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-08-31', '2020-08-31', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Violet', 'Corvus albicollis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-05-30', '2022-05-30', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Aquamarine', 'Bettongia penicillata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-19', '2019-03-19', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'Turquoise', 'Sciurus vulgaris', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-09-14', '2021-09-14', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Indigo', 'Terathopius ecaudatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-09', '2018-02-09', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Goldenrod', 'Haematopus ater', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-10-22', '2019-10-22', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Aquamarine', 'Bassariscus astutus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-02-16', '2022-02-16', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Crimson', 'unavailable', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-04-03', '2019-10-03', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Fuscia', 'Panthera tigris', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-09-08', '2020-03-08', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Orange', 'Damaliscus lunatus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2019-04-01', '2021-10-01', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 'Puce', 'Haematopus ater', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-02-01', '2018-08-01', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Blue', 'Anas bahamensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-12-31', '2021-12-31', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Teal', 'Castor canadensis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-06-26', '2019-12-26', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Red', 'Equus burchelli', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-04-04', '2021-04-04', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Goldenrod', 'Actophilornis africanus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-03-10', '2017-09-10', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'Blue', 'Tadorna tadorna', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-03-21', '2018-09-21', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Yellow', 'Sula dactylatra', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-01-08', '2020-01-08', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Green', 'Salvadora hexalepis', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-10-12', '2019-04-12', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Orange', 'Felis concolor', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-09-04', '2018-09-04', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Khaki', 'Ara macao', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-03-09', '2020-03-09', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Teal', 'Alopochen aegyptiacus', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-11-22', '2020-11-22', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Violet', 'Bettongia penicillata', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-11-12', '2021-05-12', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Violet', 'Ovis dalli stonei', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2016-01-14', '2020-01-14', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Puce', 'Phalaropus lobatus', false);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2017-04-13', '2019-10-13', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Mauv', 'Dusicyon thous', true);
insert into edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) values ('2018-07-26', '2021-07-26', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'Yellow', 'Sula nebouxii', true);

INSERT INTO Area (nome_area) VALUES ('Cultura');
INSERT INTO Area (nome_area) VALUES ('Educação');
INSERT INTO Area (nome_area) VALUES ('Tecnologia');
INSERT INTO Area (nome_area) VALUES ('Social');
INSERT INTO Area (nome_area) VALUES ('Ciência');

INSERT INTO Departamento(nome) VALUES ('Desenvolvimento Rural - DDR');
INSERT INTO Departamento(nome) VALUES ('Biotecnologia e Produção Vegetal e Animal - DBPVA');
INSERT INTO Departamento(nome) VALUES ('Ciências da Natureza, Matemática e Educação - DCNME');
INSERT INTO Departamento(nome) VALUES ('Recursos Naturais e Proteção Ambiental - DRNPA');
INSERT INTO Departamento(nome) VALUES ('Tecnologia Agroindustrial e Socioeconomia Rural - DTAiSER');
INSERT INTO Departamento(nome) VALUES ('Botânica - DB');
INSERT INTO Departamento(nome) VALUES ('Ciências Ambientais - DCAm');
INSERT INTO Departamento(nome) VALUES ('Ciências Fisiológicas - DCF');
INSERT INTO Departamento(nome) VALUES ('Ecologia e Biologia Evolutiva - DEBE');
INSERT INTO Departamento(nome) VALUES ('Educação Física e Motricidade Humana - DEFMH');
INSERT INTO Departamento(nome) VALUES ('Enfermagem - DEnf');
INSERT INTO Departamento(nome) VALUES ('Fisioterapia - DFisio');
INSERT INTO Departamento(nome) VALUES ('Genética e Evolução - DGE');
INSERT INTO Departamento(nome) VALUES ('Gerontologia - DGero');
INSERT INTO Departamento(nome) VALUES ('Hidrobiologia - DHb');
INSERT INTO Departamento(nome) VALUES ('Medicina - DMed');
INSERT INTO Departamento(nome) VALUES ('Morfologia e Patologia - DMP');
INSERT INTO Departamento(nome) VALUES ('Terapia Ocupacional - DTO');
INSERT INTO Departamento(nome) VALUES ('Computação - DC');
INSERT INTO Departamento(nome) VALUES ('Engenharia Civil - DECiv');
INSERT INTO Departamento(nome) VALUES ('Engenharia Elétrica - DEE');
INSERT INTO Departamento(nome) VALUES ('Engenharia Mecânica - DEMec');
INSERT INTO Departamento(nome) VALUES ('Engenharia de Materiais - DEMa');
INSERT INTO Departamento(nome) VALUES ('Engenharia de Produção - DEP');
INSERT INTO Departamento(nome) VALUES ('Engenharia Química - DEQ');
INSERT INTO Departamento(nome) VALUES ('Estatística - DEs');
INSERT INTO Departamento(nome) VALUES ('Física - DF');
INSERT INTO Departamento(nome) VALUES ('Matemática - DM');
INSERT INTO Departamento(nome) VALUES ('Química - DQ');
INSERT INTO Departamento(nome) VALUES ('Administração - DAdm-So');
INSERT INTO Departamento(nome) VALUES ('Computação - DComp-So');
INSERT INTO Departamento(nome) VALUES ('Economia - DEco-So');
INSERT INTO Departamento(nome) VALUES ('Engenharia de Produção de Sorocaba - DEP-So');
INSERT INTO Departamento(nome) VALUES ('Biologia - DBio - So');
INSERT INTO Departamento(nome) VALUES ('Ciências Humanas e Educação - DCHE - So');
INSERT INTO Departamento(nome) VALUES ('Geografia, Turismo e Humanidades - DGTH - So');
INSERT INTO Departamento(nome) VALUES ('Ciências Ambientais - DCA-So');
INSERT INTO Departamento(nome) VALUES ('Física, Química e Matemática - DFQM-So');
INSERT INTO Departamento(nome) VALUES ('Artes e Comunicação - DAC');
INSERT INTO Departamento(nome) VALUES ('Ciência da Informação - DCI');
INSERT INTO Departamento(nome) VALUES ('Ciências Sociais - DCSo');
INSERT INTO Departamento(nome) VALUES ('Educação - DEd');
INSERT INTO Departamento(nome) VALUES ('Filosofia e Metodologia das Ciências - DFMC');
INSERT INTO Departamento(nome) VALUES ('Letras - DL');
INSERT INTO Departamento(nome) VALUES ('Metodologia de Ensino - DME');
INSERT INTO Departamento(nome) VALUES ('Psicologia - DPsi');
INSERT INTO Departamento(nome) VALUES ('Sociologia - DS');
INSERT INTO Departamento(nome) VALUES ('Teorias e Práticas Pedagógicas - DTPP');

INSERT INTO Financiador (agencia, tipo_controle) VALUES ('Governo', 'Integral');
INSERT INTO Financiador (agencia, tipo_controle) VALUES ('CSF', 'Parcial');
INSERT INTO Financiador (agencia, tipo_controle) VALUES ('FBC', 'Parcial');

INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Waldon', '7R52TBQA', 'TX', 'Houston', 'Hollywood', 'Meadow Valley', '235');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Joly', 'XGC3L201', 'OR', 'Beaverton', 'Mid-Wilshire', 'Delaware', '44');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Emmalynne', 'X2VZAHEF', 'MN', 'Young America', 'South Los Angeles', 'Arrowood', '32776');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Steven', 'FL682MKK', 'NC', 'Raleigh', 'Tarzana', 'Sauthoff', '12132');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Johann', 'A3FHE4PV', 'CA', 'Oceanside', 'Encino', 'Crescent Oaks', '26812');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Brant', '9TU36JND', 'CA', 'Torrance', 'Watts', 'Chinook', '3');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Miranda', 'LRS3A2Y3', 'TN', 'Nashville', 'Dallas', 'Prairieview', '4');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Clayton', 'MOCGILAR', 'AL', 'Mobile', 'Mianus', 'Burrows', '9');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Buckie', '31CHJLBR', 'IL', 'Carol Stream', 'Armour Square', 'Graedel', '6');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Odilia', 'DS0XEQEI', 'FL', 'Sarasota', 'Hills', 'Chinook', '79657');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Dulcinea', 'N0REHC9O', 'FL', 'Tallahassee', 'Magnificent Miles', 'Golf View', '09035');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Ly', 'I16S0E5B', 'CA', 'Sacramento', 'Buena Vista', 'Sunnyside', '2101');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Berri', 'CAZ6PCSB', 'UT', 'Salt Lake City', 'Coral Way', 'East', '8876');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Ludwig', 'WKLF541N', 'VA', 'Hampton', 'Virginia Key', 'Pierstorff', '57844');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Tamra', '0C0ZK7JK', 'FL', 'Fort Myers', 'Edgewater', 'Southridge', '66967');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Meridith', '1I5903XI', 'NC', 'Charlotte', 'Omni', 'Manley', '47964');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Jere', 'TZ6MOROS', 'AZ', 'Scottsdale', 'Upper Eastside', 'Judy', '03301');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Derick', 'OD08ZQSJ', 'TX', 'Corpus Christi', 'Wynwood', 'Bashford', '8');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Annaliese', '3P7VJVFM', 'FL', 'Orlando', 'Allapattah', 'Esch', '77259');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Octavius', '7W9PN6CA', 'VA', 'Richmond', 'Civic Center', 'Buhler', '0372');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Carlos', 'K2Y0UXLW', 'GO', 'Goiania', 'Setor Bueno', 'T-4', '4416');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Eduardo', 'J9KLXWIG', 'PA', 'Belém', 'Vila Norte', 'Rua do Presidente', '91');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Jonathan', 'E07J89T7', 'SP', 'Sorocaba', 'Vila Paraíba', 'Rua das Minas', '99');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Vitor', 'W4YVRB7N', 'AM', 'Manaus', 'Setor Aeroporto', 'R-223', '06071');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Gustavo', 'X1ZV67L8', 'TO', 'Palmas', 'Vila Palmares', 'Rua de Frente', '41');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Fernando', 'CO5R7IZH', 'SC', 'Florianopolia', 'Setor Rosa', 'Rua Verde', '384');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Marcos', 'YUO6GDGD', 'RS', 'Porto Alegre', 'Setor Sul', 'Rua 8', '7');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Fernanda', 'EQG01WTM', 'RN', 'Natal', 'Setor Vale', 'Marginal Ceará', '8767');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Bruna', 'D433W9RE', 'RJ', 'Rio de Janeiro', 'Vila Nove ', 'Transfederônica', '3024');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Víctor', 'I5ZWXHKG', 'AL', 'Maceió', 'Setor Leste', 'Rua 99', '49');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Alfredo', '1YEFI260', 'SE', 'Aracaju', 'Vila Oito', 'T - 50', '3');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Davi', 'UJHN18CD', 'PA', 'Belém', 'Cidade Jardim', '7 de Setembro', '381');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Maomé', '9TXNVBBQ', 'RR', 'Boa Vista', 'Centro', 'Rua 9', '2');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Jande', '4BIOZ6L8', 'RO', 'Porto Velho Mission', 'Vila Oeste', 'Rua Marechal Deodoro', '57936');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Claudia', '0VNGHAOC', 'MT', 'Compo Grande', 'Centro', 'Rua 12 de Outubro', '103');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Kelen', 'VBE1J4M9', 'PE', 'Recife', 'Aflitos', 'Rua 9 de Julho', '0');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Claudio', 'GGSFG7ZC', 'MG', 'Uberlandia', 'Centro', 'Rua 15 de Novembro', '2096');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Janio', 'HM0N5XSA', 'GO', 'Goiania', 'Setor Oeste', 'P12', '62863');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Pedro', 'MQXYPDLK', 'GO', 'Goiania', 'Setor Bueno', 'A45', '7926');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Gabriel', 'RA9YNSBN', 'PA', 'Santarem', 'Aldeia', 'Bela Vista', '69');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Thales', '7WZXEFDJ', 'GO', 'Goiania', 'Setor Oeste', 'R66', '45172');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Felipe', '1T9EJ1DO', 'TO', 'Palmas', 'Jardim de Cima', 'Rosas', '69639');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Wander', 'V1EOIHFJ', 'MG', 'Belo Horizonte', ' Barão Geraldo', '', '8');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Bernardo', 'BX0NT5B4', 'PA', 'Ananindeua', '40 Horas', 'Ilha de Santa Rosa', '792');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Mariele', 'CGM97PKZ', 'MA', 'Salvador', 'Marginal', 'Rua 15 de Novembro', '37172');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Marilde', '1IP1578K', 'SP', 'São Carlos', 'Centro', 'Rua Padre Teixeira', '2955');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('João', '4CYNG6D5', 'SP', 'Santos', 'Campo Grande', 'Rua 7 de setembro', '2360');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Fabiano', '2HNBHA2M', 'SP', 'Campinas', 'Nova Aparecida', 'Rua da Vida', '9329');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Fabio', '7FPYSD1S', 'SP', 'São Paulo', 'Argentina', 'Rua dos Jogadores', '26');
INSERT INTO Pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES ('Ana', 'B0UG9S7W', 'SP', 'São Carlos', 'Jardim', 'Rua das Rosas', '174');


INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (1, 'tparkhouse0@mail.ru');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (2, 'awixey1@wordpress.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (3, 'mcornner2@nyu.edu');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (4, 'mmccleverty3@ihg.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (5, 'mkelloch4@squidoo.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (6, 'lvelez5@alibaba.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (7, 'smattys6@cnet.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (8, 'jzelner7@deviantart.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (9, 'bbaythrop8@technorati.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (10, 'jpeyto9@loc.gov');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (11, 'sashtonhursta@epa.gov');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (12, 'hcollecottb@gnu.org');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (13, 'evasyutichevc@fastcompany.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (14, 'lozintsevd@spiegel.de');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (15, 'ivollame@sogou.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (16, 'wnethercliftf@example.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (17, 'dmaccostog@symantec.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (18, 'tmurriganh@de.vu');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (19, 'dspositoi@prnewswire.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (20, 'fdonatij@nhs.uk');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (21, 'cseabrightk@usgs.gov');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (22, 'cliccardol@photobucket.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (23, 'sdorotm@google.nl');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (24, 'mburgissn@cocolog-nifty.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (25, 'jgifkinso@live.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (26, 'rallbonp@wunderground.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (27, 'ktinanq@myspace.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (28, 'bharter@youtu.be');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (29, 'bgudgers@t-online.de');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (30, 'sgothlifft@hostgator.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (31, 'achetwinu@youtube.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (32, 'bgillanv@pbs.org');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (33, 'mjoyseyw@examiner.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (34, 'iburkex@va.gov');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (35, 'gbartozziy@xrea.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (36, 'blyptritz@ning.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (37, 'knorville10@soup.io');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (38, 'tseeley11@oracle.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (39, 'mcalifornia12@list-manage.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (40, 'ihuetson13@ezinearticles.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (41, 'dgrzeszczyk14@prlog.org');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (42, 'ejedrys15@multiply.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (43, 'sbaird16@cnn.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (44, 'amarcome17@nps.gov');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (45, 'aleftridge18@mozilla.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (46, 'mraikes19@symantec.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (47, 'nsherrell1a@telegraph.co.uk');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (48, 'cwalenta1b@prlog.org');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (49, 'cbecken1c@sogou.com');
INSERT INTO Pessoa_Email (id_pessoa, email) VALUES (50, 'lsalerg1d@wiley.com');


INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (1, '172473938', '48', '45');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (2, '819400300', '45', '18');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (3, '209215053', '73', '16');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (4, '326469068', '85', '39');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (5, '530222607', '04', '20');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (6, '106861968', '62', '71');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (7, '291864780', '42', '37');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (8, '290757796', '91', '79');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (9, '720558674', '82', '33');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (10, '793317648', '80', '61');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (11, '161557441', '82', '55');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (12, '441383061', '58', '77');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (13, '944950198', '67', '96');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (14, '119777530', '96', '54');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (15, '263398230', '61', '09');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (16, '761000044', '79', '86');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (17, '888435146', '79', '90');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (18, '219816652', '95', '49');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (19, '625421118', '30', '76');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (20, '256877629', '70', '79');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (21, '953936224', '72', '46');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (22, '332381406', '60', '33');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (23, '687587064', '37', '33');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (24, '145606559', '46', '56');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (25, '946734348', '25', '40');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (26, '438411554', '61', '85');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (27, '443461544', '98', '55');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (28, '598884893', '04', '36');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (29, '060632703', '50', '26');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (30, '665691666', '13', '02');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (31, '827657957', '22', '64');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (32, '382780973', '70', '00');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (33, '193431626', '73', '90');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (34, '961974263', '95', '49');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (35, '079202667', '73', '51');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (36, '964454559', '80', '06');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (37, '905042168', '89', '18');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (38, '813211812', '97', '87');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (39, '468284475', '50', '58');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (40, '132182835', '23', '80');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (41, '121615355', '24', '89');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (42, '003643503', '57', '25');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (43, '656131075', '42', '74');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (44, '800159323', '24', '91');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (45, '137489690', '18', '70');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (46, '863588803', '25', '32');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (47, '060511817', '90', '11');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (48, '675626309', '62', '22');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (49, '943475931', '07', '10');
INSERT INTO Pessoa_Telefone (id_pessoa, fixo, ddd, ddi) VALUES (50, '992191856', '97', '88');


INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('21944766014', 21);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('53001114061', 22);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('09096358031', 23);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('60613253043', 24);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('07196807006', 25);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('12598314000', 26);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('36532433004', 27);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('89487521038', 28);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('84582423035', 29);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('02405434083', 30);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('36696703004', 31);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('71597106062', 32);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('93691048013', 33);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('27558720044', 34);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('93099752029', 35);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('09795783025', 36);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('34182923057', 37);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('40907764061', 38);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('70331723034', 39);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('89514840097', 40);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('99234847008', 41);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('59241910011', 42);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('39652597090', 43);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('92874875023', 44);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('53975252006', 45);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('52380246068', 46);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('71969254084', 47);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('71969254084', 48);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('32706613041', 49);
INSERT INTO PessoaBrasileira (cpf, id_pessoa) VALUES ('24468048026', 50);


INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('62152780', 1);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('65328286', 2);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('79096301', 3);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('42532173', 4);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('96802492', 5);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('95003828', 6);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('87675131', 7);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('62091510', 8);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('58527119', 9);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('48160481', 10);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('72579121', 11);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('89175906', 12);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('93125942', 13);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('40380189', 14);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('02391879', 15);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('66476648', 16);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('51123503', 17);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('88098126', 18);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('88298753', 19);
INSERT INTO PessoaEstrangeira (passaporte, id_pessoa) VALUES ('85874984', 20);


INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (13, 32198416);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (14, 89419689);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (15, 78416984);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (16, 87451411);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (17, 74198498);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (18, 15641894);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (19, 78984198);
-- id_pessoa 20 = externa
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (21, 48908944);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (22, 80498401);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (23, 41895418);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (24, 98748541);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (25, 88654321);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (26, 12315418);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (27, 48909864);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (28, 87984165);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (29, 48594168);
-- id_pessoa 30 = externa
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (31, 49854156);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (32, 52609526);
INSERT INTO PessoaGraduacao (id_pessoa, nro_ufscar) VALUES (33, 98564894);


INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (5, 74894185);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (6, 98564894);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (7, 87989418);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (8, 78954158);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (9, 78974000);
-- id_pessoa 10 = externa
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (11, 79874169);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (12, 75156484);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (34, 19684181);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (35, 79841861);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (36, 99635299);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (37, 21357894);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (38, 78941691);
INSERT INTO PessoaPosgraduacao (id_pessoa, nro_ufscar) VALUES (39, 74189495);


INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (1, 19, 95050055, '2017-01-31');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (2, 28, 62147982, '2019-05-16');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (3, 27, 47228839, '2019-05-11');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (4, 28, 49856418, '2019-07-04');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (40, 19, 89798419, '2016-08-12');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (41, 11, 25489651, '2018-04-25');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (42, 27, 12354879, '2016-06-24');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (43, 19, 43453245, '2016-11-21');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (44, 11, 48700229, '2016-03-28');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (45, 19, 21322545, '2019-03-27');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (46, 28, 96645321, '2017-03-01');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (47, 27, 45842302, '2017-04-01');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (48, 19, 36894121, '2016-09-12');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (49, 29, 76778655, '2017-09-16');
INSERT INTO PessoaServidor (id_pessoa, id_departamento, nro_ufscar, data_contratacao) VALUES (50, 11, 21595215, '2015-10-02');


INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (1, 19, 'Doutor', 'Professor', 'Computação', 'Efetivo');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (2, 28, 'Doutor', 'Professor', 'Exatas', 'Adjunto');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (3, 27, 'Doutor', 'Professor', 'Física', 'Efetivo');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (44, 11, 'Mestre', 'Professor', 'Biológicas', 'Substituto');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (45, 19, 'Doutor', 'Professor', 'Computação', 'Efetivo');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (46, 28, 'Doutor', 'Professor', 'Computação', 'Adjunto');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (47, 27, 'Doutor', 'Professor', 'Física', 'Substituto');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (48, 19, 'Doutor', 'Professor', 'Computação', 'Efetivo');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (49, 29, 'Doutor', 'Professor', 'Química', 'Efetivo');
INSERT INTO PessoaServidorDocente (id_pessoa, id_departamento, titulo, cargo, setor, tipo) VALUES (50, 11, 'Mestre', 'Professor', 'Biológicas', 'Substituto');


INSERT INTO PessoaServidorTecnico (id_pessoa, id_departamento) VALUES (4, 28);
INSERT INTO PessoaServidorTecnico (id_pessoa, id_departamento) VALUES (40, 19);
INSERT INTO PessoaServidorTecnico (id_pessoa, id_departamento) VALUES (41, 11);
INSERT INTO PessoaServidorTecnico (id_pessoa, id_departamento) VALUES (42, 27);
INSERT INTO PessoaServidorTecnico (id_pessoa, id_departamento) VALUES (43, 19);

INSERT INTO Extensao (nro_extensao_anterior) VALUES (null);
INSERT INTO Extensao (nro_extensao_anterior) VALUES (null);
INSERT INTO Extensao (nro_extensao_anterior) VALUES (null);
INSERT INTO Extensao (nro_extensao_anterior) VALUES (null);
INSERT INTO Extensao (nro_extensao_anterior) VALUES (null);


INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (1, 19, 95050055);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (2, 28, 62147982);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (3, 27, 47228839);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (44, 11, 48700229);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (45, 19, 21322545);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (46, 28, 96645321);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (47, 27, 45842302);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (48, 19, 36894121);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (49, 29, 76778655);
INSERT INTO Coordenador (id_pessoa, id_departamento, nro_ufscar) VALUES (50, 11, 21595215);


INSERT INTO edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) VALUES ('2015-05-20', '2015-10-20', 'Proposto dentro do Programa "Tecnologias e Estratégias de Automação" As atividades de pesquisa feitas no laboratório Tear, coordenado pelo proponente deste projeto, lidam com questões tecnológicas aplicáveis a sistemas de produção industrial.Uma das questões sempre presentes nas tarefas de validação de hipóteses em dissertações e teses, passa pela definição de cenários o mais próximo do real possível e, idealmente, em plantas de produção reais.Como o uso de plantas reais traria uma interferência bastante delicada e onerosa, usa-se modelos de simulação para a validação.No estágio das pesquisas do Tear, modelos de simulação fiéis à realidade permitem validação de muito melhor qualidade.O que é necessário para isso é um levantamento de modelos em parcerias com empresas, garantindo a fidelidade do modelo.', 'Curso', 'Modelo simulação', false);
INSERT INTO edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) VALUES ('2019-05-03', '2020-10-03', 'Este trabalho vem congregar esforços para se pensar a inserçao do uso da tecnologia no trabalho com crianças de 4 e 5 anos da Educaçao Infantil.  Geralmente quando se pensa em tecnologia para essa faixa etária, a ênfase recai sobre o uso de algum aparato eletrônico digital: tablets, celulares. Ou mesmo a montagem de kits de robótica, reduzindo-se assim drasticamente o entendimento do que a tecnologia significa para nós seres humanos. Nesse sentido calcados pela Teoria Histórico Cultural para pensar o desenvolvimento das crianças e tendo como eixos norteadores a brincadeira e as interações, compreendemos que a tecnologia envolve todas as criações humanas que alteram o ambiente natural, cultural e social no qual nos encontramos. As ferramentas tecnológicas produzidas pelo ser humano estão ao nosso lado, sendo usadas a todo o momento e os tablets, celulares, computadores agregam-se a esse universo em nosso cotidiano. Partindo dessa premissa e entendendo que não é possível pensar a tecnologia separada das ciências, matemática, engenharia e do design, procuramos construir atividades que envolvam essas áreas para auxiliar professor em seu trabalho, alterando a aproximação das crianças e da professora para com as questões tecnológicas. Nesse sentido ao propormos as atividades partimos de elementos presentes no dia a dia das crianças, permitindo que elas explorem, observem, experimentem, comparem, compartilhem, pensem em soluções. Projetem e produzam juntas objetos que as auxiliarão a compreender o funcionamento de ferramentas tecnológicas que povoam o seu cotidiano.', 'Evento', 'Programação criança', false);
INSERT INTO edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) VALUES ('2018-02-21', '2018-07-21', 'O câncer de mama é uma das doenças mais temidas pelas mulheres (Soares, 2008). De acordo com o INCA, o câncer de mama é o segundo tipo de câncer mais frequente no mundo e o mais comum entre as mulheres. Gomes, Skaba e Vieira (2002), afirmam que o câncer de mama, especialmente nos anos 80 apresentou uma alta incidência, principalmente em mulheres mais jovens. Dados de 2000 do Ministério da Saúde mostram que ele foi o segundo tipo de câncer mais incidente, sendo que, apenas 3,4% dos casos foram detectados precocemente. Em uma estimativa realizada pelo INCA o número de casos novos de câncer de mama esperados para o Brasil em 2010 será de 49.240, com um risco estimado de 49 casos a cada 100 mil mulheres) e na Região Sudeste, o câncer de mama é o mais incidente entre as mulheres, com um risco estimado de 65 casos novos por 100 mil.O câncer de mama acarreta efeitos traumáticos na vida de uma mulher, que ultrapassam a própria enfermidade, a mulher depara-se com a possibilidade da perda de um órgão altamente investido de representação, bem como o medo de uma doença sem cura, repleta de sofrimentos e estigmas (Soares, 2008). Na obra Freudiana, segundo Zecchin (2004), o seio ocupa um papel central na primitiva experiência de satisfação do bebê, tendo um papel de satisfação e frustração, estabelecendo assim uma imagem mnemônica de objeto. O seio, para Freud, é um órgão singularmente marcado por características únicas na vida de uma mulher, é um órgão sexual de intenso investimento erógeno, bem como possui uma função de identificação para a menina. Já Lacan, segundo Zecchin (2004), afirma que o seio é um objeto de valor simbólico, representante do dom da potência materna e estará presente ao longo do processo identificatório. Dessa forma, o seio é o representante simbólico da mãe real, do dom, primeiro objeto de amor, que se constitui de forma fusional, inicialmente confundindo-se com o seio, para posteriormente discriminar-se e, sendo ele o objeto fundante do sujeito e sua relação com o mundo externo.Com o diagnostico de câncer a mulher passa por alterações significativas em diversas áreas de sua vida, como trabalho, família, lazer o que traz conseqüências para o seu cotidiano e nas suas relações pessoais e no seu contexto social (Venâncio, 2004), bem como pode deixar vestígios físicos, psicológicos. Segundo Brenelli e Shinzato (1994) muitas preocupações passa a tomar conta do pensamento dessa mulher: o medo de ser estigmatizada e rejeitada ao saberem sobre sua enfermidade, a possibilidade da disseminação da doença pelo seu corpo (metástase), a queda do cabelo e o efeito disso sobre sua auto-estima, a incerteza quanto ao futuro, sua sexualidade e seu relacionamento com o parceiro e com os filhos e principalmente o medo da reincidiva. Os aspectos psicológicos exigem profundo conhecimento em relação não só a doença como também a mulher, pois a retirada de mamas, cria um abalo na imagem corporal que de acordo com Pitanguy (1992) necessita de uma assistência psicológica, pois como ressalta Greer (1974) a retirada da mama incide sobre a função procriativa de alimentação do filho, bem como a estimulação sexual. A partir destas considerações, este projeto visa enriquecer o olhar da/sobre a mulher, considerando não somente os aspectos biomédicos, mas também os aspectos simbólicos, abordando aspectos físicos, psicológicos e sociais, para que assim possa englobar todas as necessidades das mulheres no cuidado dessa doença. Faz necessário então ter profissionais que tenha condições de lidar, além da dimensão médica, buscando uma compreensão ampliada do sujeito. Assistir a mulher com câncer de mama significa compreender toda a construção da existência feminina o que colabora no entendimento de todos os aspectos que compõem o adoecimento por câncer, incorporando, assim ao tratamento do tumor, o sujeito fragilizado em suas funções de mulher e mãe. Dada a importância de compreender esse fenômeno em toda sua complexidade, concluímos que as políticas de atenção às mulheres devem formular princípios para que se possa lidar, ao mesmo tempo com o aperfeiçoamento das intervenções técnicas e com a dimensão simbólica construída na trajetória do ser portador de doença.', 'Projeto', 'Câncer de mama', false);
INSERT INTO edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) VALUES ('2017-01-10', '2017-06-10', 'O Projeto de Extensão Física Experimental para o Ensino Médio (FEEM) contará com demonstrações experimentais lúdicas e de baixo custo relacionadas a aplicações cotidianas e tecnológicas da Física e ciências correlatas. Todas as atividades (aula/palestra introdutória, discussão de pontos e situações do dia a dia e também atuais, experimentos e análise qualitativa dos resultados) serão realizados em espaço de sala de aula, para que os alunos tenham um ambiente familiar, possibilitando a integração entre alunos/professores com os proponentes deste projeto. Uma pequena avaliação abordará os conceitos aprendidos na exposição. Com isso, o bolsista do projeto terá acesso a métodos de produção de material, preparação de aula e situações de discussão sobre os experimentos, sendo por isso de grande importância acadêmica. Por outro lado, o projeto FEEM será realizado em escolas da rede pública de ensino, onde a maioria não tem acesso a laboratórios de ciências, sendo dessa forma crucial e relevante socialmente. Entre as escolas pré-selecionadas, podemos citar as Estadual Esterina Placco e a Estadual Atília Prado Margarido (ambas em São Carlos-SP). Ao fim, além de um certificado de participação, será fornecido um panfleto com detalhes de alguns cursos correlacionados ao projeto da UFSCar. Portanto, este projeto também fornece uma excelente oportunidade para que os alunos que tenham alguma inclinação para as ciências exatas, assim como para aqueles que apenas apreciam os experimentos, e que desejam conhecer mais detalhes das profissões relacionadas aos temas expostos, tais como física, química e engenharias, nas mais diferentes especialidades. Dessa forma, propõe-se neste projeto a democratização do conhecimento científico, situando os estudantes nos processos que envolvem ciência.', 'Curso', 'Fis. Exp. Ensino Médio', false);
INSERT INTO edital (data_abertura, data_encerramento, justificativa, tipo, titulo, reoferta) VALUES ('2017-05-21', '2018-04-21', 'Java é uma linguagem de programação orientada a objetos. A nossa ideia envolve o desenvolvimento das habilidades de programação e o incentivo à aprendizagem de programação orientada a objetos.O cotidiano da sociedade reflete o rápido desenvolvimento tecnológico. O fato do curso ser disponibilizado tanto para a comunidade interna quanto externa da UFSCar visa à capacitação de maneira geral do público interessado para a utilização de recursos de Tecnologia de Informação para a solução de problemas dos setores produtivos da sociedade.', 'Curso', 'Java Iniciante', false);


INSERT INTO bolsa(codigo_edital, bolsa) VALUES (1, 'CNPq R$500,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (1, 'FAPESP R$700,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (1, 'CAPS R$450,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (2, 'CNPq R$500,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (2, 'CAPS R$450,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (3, 'CNPq R$500,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (3, 'FAPESP R$700,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (4, 'CNPq R$500,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (5, 'FAPESP R$700,00');
INSERT INTO bolsa(codigo_edital, bolsa) VALUES (5, 'CAPS R$450,00');


INSERT INTO proponente(codigo_edital, proponente) VALUES (1, 'Orides Morandin');
INSERT INTO proponente(codigo_edital, proponente) VALUES (2, 'Alessandra Arce');
INSERT INTO proponente(codigo_edital, proponente) VALUES (3, 'Maria Cristina');
INSERT INTO proponente(codigo_edital, proponente) VALUES (4, 'Paulo Henrique');
INSERT INTO proponente(codigo_edital, proponente) VALUES (5, 'Sahudy Montenegro');


INSERT INTO objetivo(codigo_edital, objetivo) VALUES (1, 'Elaborar modelo de simulação');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (1, 'Representar roteiros de produção em grafos');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (2, 'Explicar o significado da tecnologia');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (2, 'Oferecer suporte didático');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (3, 'Estudar efeitos da mastectomia');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (3, 'Estimular uma vida saudável');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (4, 'Realizar experimentos de baixo custo');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (4, 'Promover a ciência experimental');
INSERT INTO objetivo(codigo_edital, objetivo) VALUES (5, 'Ensinar Java a iniciantes');


INSERT INTO ProgramaDeExtensao (nro_extensao, palavras_chave, titulo, resumo, comunidade_atingida, anotacoes_ProEx, inicio) VALUES (1, 'Modelo', 'Modelo simulação', 'O grupo de pesquisa do Tear do DC da UFSCar tem desenvolvido trabalhos que resultam em métodos e técnicas que têm sido publicadas em periódicos e eventos e também tem buscado locais de experimentação práticas de sua pesquisa. Como as pesquisas têm, em grande parte, aspectos tecnológicos, um caminho de inferir, testar e validar as técnicas e métodos se dá na sua aplicação em empresas que se envolvam de alguma maneira com a temática. Tal ação realimenta positivamente as ações de pesquisa e desenvolvimento do grupo, norteando novos trabalhos e incrementando a qualidade de formação de recursos humanos, não só pelo aprendizado de técnicas, mas também por uma maior aproximação com o ambiente industrial. A empresa parceira deste projeto trabalhará nos auxiliando a elaborar um modelo de sistema de produção em arranjo funcional, que represente fielmente uma fábrica para servir como plataforma de simulação de ensaios de pesquisas do Tear.', 'Programadores', 'Achei interessante', '2012-04-22');
INSERT INTO ProgramaDeExtensao (nro_extensao, palavras_chave, titulo, resumo, comunidade_atingida, anotacoes_ProEx, inicio) VALUES (2, 'Criança', 'Programação criança', 'Evento que busca introduzir crianças ao mundo da programação, fornecendo a elas uma oportunidade no futuro', 'Creche', 'Muito bonitinho as crianças', '2015-07-18');
INSERT INTO ProgramaDeExtensao (nro_extensao, palavras_chave, titulo, resumo, comunidade_atingida, anotacoes_ProEx, inicio) VALUES (3, 'Câncer', 'Câncer de mama', 'O câncer de mama pode fazer com que a mulher se depare com a mastectomia, que traz a realidade da mutilação e um turbilhão de sentimentos, como mudanças no cotidiano, stress, agressividade, medos, conflitos com a sexualidade, com a imagem corporal, com a identidade feminina e na relação conjugal. Dessa forma, esse projeto tem como objetivo realizar ações de suporte técnico e psicossocial às mulheres mastectomizadas da região de São Carlos, contribuindo para uma visão ampliada dessas mulheres. A partir da concepção de um grupo de apoio, o presente projeto propõe identificar necessidades por meio de entrevistas semi estruturadas e planejar ações educativas e oficinas.', 'Paciente de câncer', 'Câncer realmente é triste', '2012-11-17');
INSERT INTO ProgramaDeExtensao (nro_extensao, palavras_chave, titulo, resumo, comunidade_atingida, anotacoes_ProEx, inicio) VALUES (4, 'Experimental', 'Fis. Exp. Ensino Médio', 'Trata-se da realização de experimentos lúdicos de baixo custo com alunos do Ensino Médio (EM) a fim de transmitir, através do conhecimento científico e cotidiano adquiridos, o caráter experimental das disciplinas de ciências. Partindo deste objetivo principal, o projeto possui algumas metas, tais como abordar na prática os conceitos de física básica discutidos no EM, a conscientização sobre a importância da ciência, permitir a discussão dos resultados das experiências (visto que a maioria não tem acesso a laboratórios), etc. Ademais, pretende promover uma forte interação entre a comunidade acadêmica e a comunidade da rede pública de ensino (alunos e professores), sendo uma importante iniciativa.', 'Físicos', 'Não entendi, mas gostei', '2012-05-24');
INSERT INTO ProgramaDeExtensao (nro_extensao, palavras_chave, titulo, resumo, comunidade_atingida, anotacoes_ProEx, inicio) VALUES (5, 'Java', 'Java Iniciante', 'Oferecer aos interessados recursos básicos de programação e de orientação a objetos em Java.', 'Geral', 'Importante para a comunidade de programadores', '2014-07-27');


INSERT INTO AtividadeDeExtensao (nro_extensao, nro_extensao_programa, id_financiador, id_area_pr, id_area_se, publico_alvo, palavras_chave, resumo, data_aprovacao, inicio_previsto, fim_previsto, inicio_real, fim_real, tipo_atividade, titulo, status) VALUES (1, 1, 3, 3, 2, 'Estudantes de Computação', 'Modelo', 'O grupo de pesquisa do Tear do DC da UFSCar tem desenvolvido trabalhos que resultam em métodos e técnicas que têm sido publicadas em periódicos e eventos e também tem buscado locais de experimentação práticas de sua pesquisa. Como as pesquisas têm, em grande parte, aspectos tecnológicos, um caminho de inferir, testar e validar as técnicas e métodos se dá na sua aplicação em empresas que se envolvam de alguma maneira com a temática. Tal ação realimenta positivamente as ações de pesquisa e desenvolvimento do grupo, norteando novos trabalhos e incrementando a qualidade de formação de recursos humanos, não só pelo aprendizado de técnicas, mas também por uma maior aproximação com o ambiente industrial. A empresa parceira deste projeto trabalhará nos auxiliando a elaborar um modelo de sistema de produção em arranjo funcional, que represente fielmente uma fábrica para servir como plataforma de simulação de ensaios de pesquisas do Tear.', '2015-05-20', '2015-11-20', '2017-11-20', '2015-11-20', null, 'Curso', 'Modelo simulação', 'Em andamento');
INSERT INTO AtividadeDeExtensao (nro_extensao, nro_extensao_programa, id_financiador, id_area_pr, id_area_se, publico_alvo, palavras_chave, resumo, data_aprovacao, inicio_previsto, fim_previsto, inicio_real, fim_real, tipo_atividade, titulo, status) VALUES (2, 2, 3, 4, 2, 'Estudantes de Computação', 'Creche', 'Este projeto de extensão desenvolvido em parceria por docentes do Departamento de Computação e do Departamento de Educação da Universidade Federal de São Carlos com a participação de discentes do Programa de Pós Graduação em Educação (PPGE/UFSCar), surgiu da instigante proposição de tornar a tecnologia um instrumento a ser utilizado pelo professor para desvelar às crianças o que não está visível nos aparatos tecnológicos que a cercam em seu dia a dia. Ao pensar sobre esses objetos os materiais que os constituem, o design escolhido para sua construção, ao procurar montá-los, consertá-los quando não funcionam e compartilhar os resultados com os colegas, as crianças sob a orientação do professor estarão deixando o lugar de simples usuárias para inserirem-se em uma outra dimensão de interação com a tecnologia que as cerca. Alicerçados  no conjunto de estudos e pesquisas no campo da Teoria Histórico Cultural (também conhecida como escola de Vygotsky) objetivamos o desenvolvimento nas crianças de sua curiosidade, de sua persistência, da capacidade de pensar de forma flexiva e reflexiva e, de trabalhar de forma colaborativa. Assim contribuiremos para o desenvolvimento da imaginação e do pensamento criativo.  Procuramos também formar o professor como um sujeito ativo nesse processo de apropriação das crianças pelo conhecimento cientifico que compõem as áreas em questão. Os professores participantes experimentarão, vivenciarão em suas salas de aula a proposta para esse trabalho sendo também coautores do mesmo, auxiliando no processo de reflexão e avaliação, bem como propondo também atividades e caminhos metodológicos mais eficazes. Para atingirmos o objetivo proposto partiremos da exploração dos materiais e designs necessários para a construção de três objetos que participam de nossa vida cotidiana e da vida das crianças: a lanterna, o controle remoto, um carrinho de controle remoto. A construção desses três objetos será entremeada por vários experimentos para que a criança explore ao máximo os matérias que os formarão e, para que pensem também no design desses objetos. Para além da simples introdução de um robô na sala de aula objetivamos que a criança observe, construa, experimente os materiais, elementos que constituem alguns objetos cotidianos e os recriem em sala de aula. O projeto terá três etapas de execução: a primeira será constituída de um curso de 20 horas de formação ‘mão na massa’ para os professores, onde serão montados os objetos em questão e discutidas questões conceituais e científicas que os constituem, assim como apresentados roteiros para as aulas a serem discutidos/compartilhados com os participantes. A segunda etapa será a de aplicação das atividades propostas com as crianças, sendo essa etapa acompanhada por encontros mensais com a equipe da UFSCar e, quando possível participação da equipe nas aulas com as crianças. A terceira e última etapa será a de avaliação do trabalho realizado para que se possa apreender os sucessos, fracassos e seus porquês, objetivando a melhoria da proposição em pauta. O tempo estimado de duração do projeto é de um ano letivo. O público alvo são professoras que atuam com crianças de 4 a 5 anos na Educação Infantil na  creche da USP de São Carlos. Serão fornecidos para a escola os materiais necessários na forma de kits para a realização dos trabalhos propostos, assim como sugestão de roteiros de aula para a exploração dos materiais e a construção dos objetos. Para o registro do trabalho a ser realizado com as professoras e delas com as crianças serão utilizadas filmagens, fotografias, e relatos do trabalho realizado em sala de aula. Criar-se também para fins de divulgação ampla do trabalho realizado um site com o objetivo de permitir o acesso a professores e professoras do país. Espera-se que com esse trabalho consigamos abrir novos caminhos para pensarmos a presença da tecnologia em sala de aula e o papel importante que o ensino de ciências possui para o desenvolvimento infantil.', '2019-05-03', '2020-11-03', '2022-05-03', null, null, 'Evento', 'Programação criança', 'Não iniciado');
INSERT INTO AtividadeDeExtensao (nro_extensao, nro_extensao_programa, id_financiador, id_area_pr, id_area_se, publico_alvo, palavras_chave, resumo, data_aprovacao, inicio_previsto, fim_previsto, inicio_real, fim_real, tipo_atividade, titulo, status) VALUES (3, 3, 1, 5, 4, 'Biólogos', 'Câncer', 'O câncer de mama pode fazer com que a mulher se depare com a mastectomia, que traz a realidade da mutilação e um turbilhão de sentimentos, como mudanças no cotidiano, stress, agressividade, medos, conflitos com a sexualidade, com a imagem corporal, com a identidade feminina e na relação conjugal. Dessa forma, esse projeto tem como objetivo realizar ações de suporte técnico e psicossocial às mulheres mastectomizadas da região de São Carlos, contribuindo para uma visão ampliada dessas mulheres. A partir da concepção de um grupo de apoio, o presente projeto propõe identificar necessidades por meio de entrevistas semi estruturadas e planejar ações educativas e oficinas.', '2018-02-21', '2018-08-21', '2020-08-21', '2019-02-21', null, 'Projeto', 'Câncer de mama', 'Em andamento');
INSERT INTO AtividadeDeExtensao (nro_extensao, nro_extensao_programa, id_financiador, id_area_pr, id_area_se, publico_alvo, palavras_chave, resumo, data_aprovacao, inicio_previsto, fim_previsto, inicio_real, fim_real, tipo_atividade, titulo, status) VALUES (4, 4, 2, 5, 2, 'Físicos', 'Quântica', 'Trata-se da realização de experimentos lúdicos de baixo custo com alunos do Ensino Médio (EM) a fim de transmitir, através do conhecimento científico e cotidiano adquiridos, o caráter experimental das disciplinas de ciências. Partindo deste objetivo principal, o projeto possui algumas metas, tais como abordar na prática os conceitos de física básica discutidos no EM, a conscientização sobre a importância da ciência, permitir a discussão dos resultados das experiências (visto que a maioria não tem acesso a laboratórios), etc. Ademais, pretende promover uma forte interação entre a comunidade acadêmica e a comunidade da rede pública de ensino (alunos e professores), sendo uma importante iniciativa.', '2017-01-10', '2017-07-10', '2018-07-10', '2018-07-10', '2019-07-10', 'Curso', 'Fis. Exp. Ensino Médio', 'Finalizado');
INSERT INTO AtividadeDeExtensao (nro_extensao, nro_extensao_programa, id_financiador, id_area_pr, id_area_se, publico_alvo, palavras_chave, resumo, data_aprovacao, inicio_previsto, fim_previsto, inicio_real, fim_real, tipo_atividade, titulo, status) VALUES (5, 5, 1, 3, 2, 'Público geral', 'Java', 'Oferecer aos interessados recursos básicos de programação e de orientação a objetos em Java.', '2017-05-21', '2018-05-21', '2019-05-21', '2019-05-21', null, 'Curso', 'Java Iniciante', 'Em andamento');


INSERT INTO CoordenadorCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao, Cargo) VALUES (1, 19, 1, '2015-11-20','2017-11-20', 'Coordenador');
INSERT INTO CoordenadorCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao, Cargo) VALUES (45, 19, 1, '2017-11-21', null, 'Coordenador');
INSERT INTO CoordenadorCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao, Cargo) VALUES (50, 11, 3, '2019-02-21', null, 'Coordenador');
INSERT INTO CoordenadorCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao, Cargo) VALUES (47, 27, 4, '2018-07-10','2019-01-20', 'Coordenador');
INSERT INTO CoordenadorCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao, Cargo) VALUES (3, 27, 4, '2019-01-21', '2019-07-10', 'Coordenador');
INSERT INTO CoordenadorCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao, Cargo) VALUES (1, 19, 5, '2019-05-21', null, 'Coordenador');


INSERT INTO CoordenadorViceCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao) VALUES (45, 19, 1, '2015-11-20', '2017-11-20');
INSERT INTO CoordenadorViceCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao) VALUES (46, 28, 1, '2017-11-21', null);
INSERT INTO CoordenadorViceCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao) VALUES (44, 11, 3, '2019-02-21', null);
INSERT INTO CoordenadorViceCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao) VALUES (3, 27, 4, '2018-07-10','2019-01-20');
INSERT INTO CoordenadorViceCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao) VALUES (47, 27, 4, '2019-01-21', '2019-07-10');
INSERT INTO CoordenadorViceCoordenaAtividade (id_pessoa, id_departamento, nro_extensao, InicioCoordenacao, FimCoordenacao) VALUES (48, 19, 5, '2019-05-21', null);


INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (5,  1, 10, 10);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (6,  4, 4, 6);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (7,  3, 100, 7);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (8,  2, 70, 5);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (9,  5, 90, 9);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (10, 2, 50, 8);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (11, 4, 2, 8);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (12, 1, 100, 6);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (13, 5, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (14, 5, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (15, 3, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (16, 5, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (17, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (18, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (19, 5, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (20, 4, 2, 7);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (21, 3, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (22, 5, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (23, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (24, 4, 3, 9);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (25, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (26, 1, 75, 7);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (27, 3, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (28, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (29, 3, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (30, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (31, 3, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (32, 4, 0, 10);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (33, 4, 2, 6);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (34, 1, 15, 7);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (35, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (36, 4, 1, 4);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (37, 2, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (38, 5, null, null);
INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (39, 1, 100, 10);


INSERT INTO Selecao (nro_inscritos, vagas_interno, vagas_externo) VALUES (null, 10, 2);
INSERT INTO Selecao (nro_inscritos, vagas_interno, vagas_externo) VALUES (null, 20, 3);
INSERT INTO Selecao (nro_inscritos, vagas_interno, vagas_externo) VALUES (null, 20, 2);
INSERT INTO Selecao (nro_inscritos, vagas_interno, vagas_externo) VALUES (null, 20, 3);
INSERT INTO Selecao (nro_inscritos, vagas_interno, vagas_externo) VALUES (null, 10, 1);


INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES  (5, 1, 1, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES  (6, 4, 4, 'Faltou', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES  (7, 3, 3, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES  (8, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES  (9, 5, 5, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (10, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (11, 4, 4, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (12, 1, 1, 'Faltou', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (13, 5, 5, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (14, 5, 5, 'Presente', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (15, 3, 3, 'Presente', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (16, 5, 5, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (17, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (18, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (19, 5, 5, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (20, 4, 4, 'Presente', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (21, 3, 3, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (22, 5, 5, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (23, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (24, 4, 4, 'Faltou', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (25, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (26, 1, 1, 'Presente', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (27, 3, 3, 'Faltou', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (28, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (29, 3, 3, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (30, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (31, 3, 3, 'Presente', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (32, 4, 4, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (33, 4, 4, 'Presente', true);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (34, 1, 1, 'Presente', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (35, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (36, 4, 4, 'Presente', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (37, 2, 2, null, null);--CERTO
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (38, 5, 5, 'Faltou', false);
INSERT INTO Participante_participa_Selecao (id_pessoa, nro_extensao, id_selecao, declaracao_presenca, selecionado) VALUES (39, 1, 1, 'Presente', true);