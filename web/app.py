from flask import Flask, render_template, g, redirect, flash
from flask import Blueprint, request, session, url_for
import db
import os
import auth

app = Flask(__name__)
app.config.from_mapping(
		SECRET_KEY='dev',
		DATABASE=os.path.join(app.instance_path, 'flaskr.postgres'),
	)
app.register_blueprint(auth.bp)


@app.route('/')
def index():
	return render_template('index.html')
	
@app.route('/editais/abertos/')
def editais1():
	ed = db.editais(pagina = 0)
	qtd = db.qtdEditais()
	return render_template('editaisAbertos.html', editais = ed, page = 0, qtd = qtd)
	
@app.route('/editais/fechados/')
def editais3():
	ed = db.editais(pagina = 0, abertos=False)
	qtd = db.qtdEditais(abertos=False)
	return render_template('editaisFechados.html', editais = ed, page = 0, qtd = qtd)

@app.route('/editais/abertos/<page>/')
def editais2(page):
	ed = db.editais(pagina = int(page)*15)
	qtd = db.qtdEditais()
	return render_template('editaisAbertos.html', editais = ed, page = int(page), qtd = qtd)

@app.route('/editais/fechados/<page>/')
def editais4(page):
	ed = db.editais(pagina = int(page)*15, abertos=False)
	qtd = db.qtdEditais(abertos=False)
	return render_template('editaisFechados.html', editais = ed, page = int(page), qtd = qtd)

@app.route('/aciepes/')
def aciepes1():
	return render_template('aciepes.html')
	
@app.route('/atividades/')
def atividades1():
	id_pessoa = 0
	try:
		if session['user']:
			id_pessoa = session['user']
	except:
		id_pessoa = 0
	ats, res = db.ListaAtividades(id_pessoa)
	return render_template('atividades.html', ats=ats, res = res)
	
@app.route('/atividades/inscricao/<id_atividade>/')
def inscrever(id_atividade):
	if session['user']:
		id_pessoa = session['user']
		db.inscreverAtividade(id_pessoa, id_atividade)
		
		selecoes, participacao = db.getParticipacao(session['user'])
		return render_template('pessoalParticipante.html', selecoes = selecoes, participacao = participacao)
	else:
		return render_template('login.html')

@app.route('/teste/')
def helloDB():
	db.initDB()
	return "Hello DB!"  
	
@app.route('/extra/')
def extra():
	db.extra()
	return "More DB!"  
	
@app.route('/login/', methods=['GET', 'POST'])
def login():
	dep = db.listaDep()
	if request.method == 'POST':
		cpf = request.form['Username']
		senha = request.form['password']
		if not cpf:
			flash('Sem CPF ou Passaporte')
		elif not senha:
			flash('Sem Senha')
		else:
			dados, coordena, servidor, graduacao, posgraduacao = db.checaPessoa(cpf)
			if dados:
				session['user'] = dados[0]
				session['nome'] = dados[1]
				session['e_coordenador'] = coordena[0]
				session['e_servidor'] = servidor[0]
				session['e_graduacao'] = graduacao[0]
				session['e_posgraduacao'] = posgraduacao[0]
				session['cpf_pass'] = cpf
				g.user = session['user']
				g.nome = session['nome']

				return redirect('/minhaarea/')
		
	return render_template('login.html', departamento = dep)

@app.route('/logout/')
def logout():
	session.clear()
	return redirect('/')

@app.route('/minhaarea/')
def minhaarea():
	if not session.get('user'):
		return redirect('/login')
		
	g.user = session['user']
	g.nome = session['nome']
	tituloCargo, iddepNroData, nomeDep, endereco, emails, telefones = db.getInformacoes(session['user'])
	return render_template('pessoal.html', 
		tituloCargo = tituloCargo, 
		iddepNroData = iddepNroData, 
		nomeDep = nomeDep, 
		endereco = endereco, 
		emails = emails, 
		telefones = telefones)
	
@app.route('/minhaarea/participantes/')
def minhaparticipacao():
	if not session['user']:
		return redirect('/login')
		
	selecoes, participacao = db.getParticipacao(session['user'])
	return render_template('pessoalParticipante.html', selecoes = selecoes, participacao = participacao)

@app.route('/minhaarea/coordenador/')
def minhacoordenacao():
	if not session.get('user'):
		return redirect('/login')
	if not session.get('e_coordenador'):
		return redirect('/minhaarea/')
	
	atividades = db.getAtividadesCoordenando(session['user'])
	return render_template('pessoalCoordenador.html', atividades=atividades)

	
@app.route('/registrar/', methods=['GET', 'POST'])
def registrar():
	if request.method == 'POST':
		nome = request.form['nome']
		cpf = request.form['cpf']
		senha = request.form['senha']
		estado = request.form['estado']
		cidade = request.form['cidade']
		bairro = request.form['bairro']
		rua = request.form['rua']
		numero = request.form['numero']
		funcao = request.form['funcao']
		numeroUFSCar = request.form['numeroUFSCar']
		dep = request.form['departamento']
		
		if not nome:
			flash('Sem nome')
		elif not cpf:
			flash('Dados incorretos')
		elif not senha:
			flash('Dados incorretos')
		elif not cidade:
			flash('Dados incorretos')
		elif not bairro:
			flash('Dados incorretos')
		elif not rua:
			flash('Dados incorretos')
		elif not numero:
			flash('Dados incorretos')
		elif not funcao:
			flash('Dados incorretos')
		else:
			id_pessoa = db.criaPessoa(nome, cpf, senha, estado, cidade, bairro, rua, numero, funcao, numeroUFSCar, dep)
			if id_pessoa > -1:
				g.user = id_pessoa
				g.nome = nome
		
	return render_template('index.html')
	
@app.route('/editais/<id_edital>/')
def editaisDetalhes(id_edital):
	ed, proponente, bolsa, objetivo, atividade, disposicao = db.editaisDetalhes(id_edital)

	return render_template('editalDetalhes.html', ed = ed, proponentes = proponente, bolsas = bolsa, objetivos = objetivo, atividades = atividade, disposicoes = disposicao)
	
# Inserida por Vitor
@app.route('/atividades/<id_atividade>/')
def atividadesDetalhes(id_atividade):
	at, nome_area1, nome_area2, agencia, titulo, ac, ace = db.atividadeComDetalhes(id_atividade)

	participantes = None
	coordenadores = None
	versao_anterior = None
	verba = 0

	if session.get('e_coordenador'):
		verba = db.getVerba(id_atividade)[0] or 0.00
		print(verba)
		participantes = db.getAllParticipantes(id_atividade)
		coordenadores = db.getCoordenadoresAnteriores(id_atividade)
		versao_anterior = db.getVersaoAnterior(id_atividade)[0]
	
	return render_template('atividadeExtDetalhes.html', at = at, nome_area1 = nome_area1, nome_area2 = nome_area2, agencia = agencia, programa = titulo, ac = ac, aces = ace,participantes=participantes, coordenadores=coordenadores,versao_anterior=versao_anterior,verba=verba)
	
# Inserida por Vitor
@app.route('/participantes/<id_atividade>')
def participanteInfos(id_atividade):
	if not session.get('user'):
		return render_template('login.html')
	id_participante = session['user']
	part, titulo, nome, coordena = db.participantesInfos(id_atividade, id_participante)

	return render_template('participantesInfo.html', part = part, titulo = titulo, nome = nome, coordena = coordena)
	
@app.route('/aciepes/detalhes/<id_edital>/')
def aciepesDetalhes(id_edital):
	return render_template('aciepeDetalhes.html')

if __name__ == '__main__':
	app.run(host='0.0.0.0',port=5000,debug=True)
