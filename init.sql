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

insert into bolsa(codigo_edital, bolsa) values (1, 'CNPq R$500,00');
insert into bolsa(codigo_edital, bolsa) values (1, 'FAPESP R$700,00');
insert into bolsa(codigo_edital, bolsa) values (1, 'CAPS R$450,00');

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

