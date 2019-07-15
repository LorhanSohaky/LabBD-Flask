import os
import psycopg2
from flask import current_app, g

conn = psycopg2.connect(host=os.environ['DATABASE_URL'], database='marilde',user='postgres', password=os.environ['POSTGRES_PASSWORD'],port=os.environ['POSTGRES_PORT'])


def initDB():
    print("Criando todas as tabelas...")
    with conn.cursor() as cursor:
        cursor.execute(open("schema.sql", "r").read())
    conn.commit()	
    conn.commit()
    
    
    print("Banco de Dados pronto para o uso")
    
def qtdEditais(abertos=True):
    code = "SELECT count(*) FROM vEditais_Abertos"
    if not abertos:
        code = "SELECT count(*) FROM vEditais_Fechados"

    with conn.cursor() as cur:
        cur.execute(code)
        dados = cur.fetchone()
        return int(dados[0])

def extra():
    curs = conn.cursor()
    curs.execute("ROLLBACK")
    conn.commit()

def editaisDetalhes(id_ed):
    with conn.cursor() as cur:
        cur.execute("SELECT data_abertura, data_encerramento, tipo, titulo, codigo FROM edital WHERE codigo = %s;", [id_ed])
        dado1 = cur.fetchone()
        cur.execute("SELECT proponente FROM proponente WHERE codigo_edital = %s;", [id_ed])
        dado2 = cur.fetchall()
        
        cur.execute("SELECT bolsa FROM bolsa WHERE codigo_edital = %s;", [id_ed])
        dado3 = cur.fetchall()
        
        cur.execute("SELECT objetivo FROM objetivo WHERE codigo_edital = %s;", [id_ed])
        dado4 = cur.fetchall()
        
        cur.execute("SELECT atividade, data FROM cronograma WHERE codigo_edital = %s;", [id_ed])
        dado5 = cur.fetchall()

        cur.execute("SELECT disposicao FROM disposicoes_gerais WHERE codigo_edital = %s;", [id_ed])
        dado6 = cur.fetchall()

        return dado1, dado2, dado3, dado4, dado5, dado6

def editais(pagina = 0, abertos = True):
    code = "SELECT * FROM vEditais_Abertos ORDER BY tempo_restante ASC, titulo LIMIT 15 OFFSET %s;"
    if not abertos:
        code = "SELECT * FROM vEditais_Fechados ORDER BY data_encerramento DESC, titulo LIMIT 15 OFFSET %s;"

    with conn.cursor() as cur:
        cur.execute(code, [pagina])
        dados = cur.fetchall()
        return dados
        
def checaPessoa(cpf):
    with conn.cursor() as cur:
        
        cur.execute("SELECT id_pessoa, nome FROM vCpfPassaporte WHERE cpfoupass = %s;", [cpf])
        dados = cur.fetchone()
        cur.execute("SELECT count(*) FROM CoordenadorCoordenaAtividade WHERE id_pessoa = %s;", [dados[0]])
        coordena = cur.fetchone()
        cur.execute("SELECT count(*) FROM PessoaServidor WHERE id_pessoa = %s;", [dados[0]])
        servidor = cur.fetchone()
        cur.execute("SELECT count(*) FROM PessoaGraduacao WHERE id_pessoa = %s;", [dados[0]])
        graduacao = cur.fetchone()
        cur.execute("SELECT count(*) FROM PessoaPosgraduacao WHERE id_pessoa = %s;", [dados[0]])
        posgraduacao = cur.fetchone()
        return dados, coordena, servidor, graduacao, posgraduacao
        
def criaPessoa(nome, cpf, senha, estado, cidade, bairro, rua, numero, funcao):
    curs = conn.cursor()
    curs.execute("ROLLBACK")
    conn.commit()

    id_novo = -1
    with conn.cursor() as cur:
        cur.execute("INSERT INTO pessoa (nome, senha, uf, cidade, bairro, rua, numero) VALUES (%s, %s, %s, %s, %s, %s, %s);", [nome, senha, estado, cidade, bairro, rua, numero])
        cur.execute("SELECT id_pessoa FROM Pessoa WHERE nome = %s", [nome])
        id_novo = cur.fetchone()[0]
            
        cur.execute("INSERT INTO pessoabrasileira (cpf, id_pessoa) VALUES (%s, %s);", [cpf, id_novo])
        if funcao == "Discente":
            cur.execute("INSERT INTO PessoaGraduacao (nro_ufscar, id_pessoa) VALUES (%s, %s);", [id_novo, id_novo])
    conn.commit()
    return id_novo

def ListaAtividades(id_pessoa):
    cur = conn.cursor()
    cur.execute("SELECT * FROM vAtividades;")
    dados = cur.fetchall()
    
    resultados = []
    if id_pessoa > 0:
        for d in dados:
            cur.callproc('VerificaInscricao', [id_pessoa, d[0]])
            R = cur.fetchone()
            resultados.append([d[0], R[0]])
    return dados, resultados

# Inserida por Vitor
def atividadeComDetalhes(id_at):
    cur = conn.cursor()
    cur.execute("SELECT nro_extensao, publico_alvo, palavras_chave, resumo, inicio_real, fim_real, inicio_previsto, fim_previsto, data_aprovacao, tipo_atividade, titulo, status FROM AtividadeDeExtensao WHERE nro_extensao = %s;", [id_at])
    dado1 = cur.fetchone()

    cur.execute("SELECT nome_area FROM Area, AtividadeDeExtensao WHERE id_area = id_area_pr and nro_extensao = %s;", [id_at])
    dado2 = cur.fetchall()

    cur.execute("SELECT nome_area FROM Area, AtividadeDeExtensao WHERE id_area = id_area_se and nro_extensao = %s;", [id_at])
    dado3 = cur.fetchall()

    cur.execute("SELECT agencia FROM Financiador f, AtividadeDeExtensao a WHERE f.id_financiador = a.id_financiador and nro_extensao = %s;", [id_at])
    dado4 = cur.fetchall()

    cur.execute("SELECT a.titulo FROM ProgramaDeExtensao p, AtividadeDeExtensao a WHERE p.nro_extensao = a.nro_extensao_programa and a.nro_extensao = %s;", [id_at])
    dado5 = cur.fetchall()

    cur.execute("SELECT  nro_extensao, horario_aulas, ementa, carga_horaria_prevista FROM Aciepe WHERE nro_extensao = %s;", [id_at])
    dado6 = cur.fetchall()

    cur.execute("SELECT  nro_extensao, data, horario, local, campus FROM Aciepe_Encontros WHERE nro_extensao = %s;", [id_at])
    dado7 = cur.fetchall()
    
    

    return dado1, dado2, dado3, dado4, dado5, dado6, dado7
        
# Inserida por Vitor
def participantesInfos(id_atividade, id_part,):
    cur = conn.cursor()
    cur.execute("SELECT id_pessoa, nro_extensao, frequencia, avaliacao FROM Participante WHERE id_pessoa = %s and nro_extensao = %s;", [id_part, id_atividade]) 
    dado1 = cur.fetchone()

    cur.execute("SELECT titulo, status, resumo FROM AtividadeDeExtensao a WHERE  a.nro_extensao = %s;",[id_atividade]) 
    dado2 = cur.fetchone()

    cur.execute("SELECT nome FROM Pessoa a WHERE a.id_pessoa = %s;",[id_part]) 
    dado3 = cur.fetchone()
    
    cur.execute("SELECT P.nome, E.email FROM Pessoa P, Pessoa_Email E, CoordenadorCoordenaAtividade C WHERE P.id_pessoa = E.id_pessoa and P.id_pessoa = C.id_pessoa and C.nro_extensao = %s;", [id_atividade])
    dado4 = cur.fetchone()
    return dado1, dado2, dado3, dado4


def getInformacoes(id_pessoa):
    cur = conn.cursor()
    
    cur.execute("SELECT titulo, cargo FROM PessoaServidorDocente WHERE id_pessoa = %s;", [id_pessoa])
    tituloCargo = cur.fetchone()
    
    cur.execute("SELECT id_departamento, nro_ufscar, data_contratacao FROM PessoaServidor WHERE id_pessoa = %s;", [id_pessoa])
    iddepNroData = cur.fetchone()
    
    if iddepNroData:
        cur.execute("SELECT nome from Departamento WHERE id_departamento = %s;", [iddepNroData[0]])
        nomeDep = cur.fetchone()
    else:
        nomeDep = ['--']
    
    cur.execute("SELECT uf, cidade, bairro, rua, numero FROM Pessoa WHERE id_pessoa = %s;", [id_pessoa])
    endereco = cur.fetchone()
    
    cur.execute("SELECT email FROM Pessoa_Email WHERE id_pessoa = %s;", [id_pessoa])
    emails = cur.fetchall()
    
    cur.execute("SELECT ddi, ddd, fixo FROM Pessoa_Telefone WHERE id_pessoa = %s;", [id_pessoa])
    telefones = cur.fetchall()
    
    return tituloCargo, iddepNroData, nomeDep, endereco, emails, telefones
    
def getParticipacao(id_pessoa):
    cur = conn.cursor()
    
    cur.execute("SELECT P.titulo, S.id_selecao, S.declaracao_presenca, S.selecionado FROM Participante_participa_Selecao S, ProgramaDeExtensao P WHERE id_pessoa = %s and P.nro_extensao = S.nro_extensao;", [id_pessoa])
    selecao = cur.fetchall()
    
    cur.execute("SELECT P.titulo, P.nro_extensao FROM Participante Part, ProgramaDeExtensao P WHERE Part.id_pessoa = %s and P.nro_extensao = Part.nro_extensao;", [id_pessoa])
    participacao = cur.fetchall()
    return selecao, participacao

def inscreverAtividade(id_pessoa, id_atividade):
    cur = conn.cursor()
    cur.execute("INSERT INTO Participante (id_pessoa, nro_extensao, frequencia, avaliacao) VALUES (%s,  %s, null, null);", [id_pessoa, id_atividade])
    conn.commit()

def getAtividadesCoordenando(id_pessoa):
    cur = conn.cursor()
    
    cur.execute("SELECT A.nro_extensao, A.tipo_atividade, A.titulo, A.resumo, A.status FROM AtividadeDeExtensao A, CoordenadorCoordenaAtividade coor, Coordenador cor WHERE cor.id_pessoa = %s and cor.id_pessoa = coor.id_pessoa and coor.nro_extensao = A.nro_extensao;", [id_pessoa])
    atividades = cur.fetchall()

    return atividades

def getAllParticipantes(nro_extensao):
    cur = conn.cursor()
    
    cur.execute("SELECT pessoa.nome, pessoa.id_pessoa, frequencia, avaliacao FROM pessoa, participante, AtividadeDeExtensao WHERE AtividadeDeExtensao.nro_extensao = participante.nro_extensao AND participante.id_pessoa = pessoa.id_pessoa and AtividadeDeExtensao.nro_extensao=%s;", [nro_extensao])
    return cur.fetchall()