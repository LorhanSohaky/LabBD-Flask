import os
import psycopg2
from flask import current_app, g

conn = psycopg2.connect(host=os.environ['DATABASE_URL'],database='marilde', user='postgres', password=os.environ['POSTGRES_PASSWORD'])
	
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
	
	with conn.cursor() as cursor:
		cursor.execute(open("schema_edital_create.sql", "r").read())
		cursor.execute(open("schema_insert_view.sql", "r").read())
	conn.commit()
	
def editaisDetalhes(id_ed):
	with conn.cursor() as cur:
		cur.execute("SELECT * FROM vEditais_com_detalhes WHERE id_edital = %s;", [id_ed])
		ed = cur.fetchone()
		print(ed)
		return ed

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
		cur.execute("SELECT id_pessoa, senha, nome FROM vCpfPassaporte")
		dados = cur.fetchone()
		print(dados)
		
		cur.execute("SELECT id_pessoa, senha, nome FROM vCpfPassaporte WHERE cpfoupass = %s;", [cpf])
		dados = cur.fetchone()
		print(dados)
		return dados
		
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


		
		
		
		
