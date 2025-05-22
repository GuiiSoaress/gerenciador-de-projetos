import streamlit as st
import pandas as pd
import conexao

#funcoes

@st.dialog("Cadastrar Projeto")
def cadastrar_projeto():
    nome = st.text_input("Nome do projeto: ")
    descricao= st.text_input("Descrição do projeto:")
    data_inicio = st.date_input("Data de Inicio")
    
    col1, col2, col3= st.columns([2, 2, 3])

    with col1:
        if st.button("Cadastrar"):
            try:
                conexao_db = conexao.obter_conexao()
                cursor = conexao_db.cursor()
                

                comando = (
                    "INSERT INTO projeto (nome, descricao, data_inicio) "
                    "VALUES (%s, %s, %s)"
                )
                
                valores = (nome, descricao, data_inicio)
                
                cursor.execute(comando, valores)
                
                conexao_db.commit()
                
                cursor.close()
                conexao_db.close()
                
                st.success('Projeto cadastrado com sucesso!')
                    
            except Exception as erro:
                st.warning("Erro ao cadastrar! ERRO: " + erro)
                
    with col2: 
        if st.button("Fechar"):
            st.rerun()
            
            
@st.dialog("Cadastrar Membro")
def cadastrar_Membro():
    nome = st.text_input("Nome : ")
    email= st.text_input("Email:")
    cargo = st.text_input("Cargo")
    
    col1, col2, col3= st.columns([2, 2, 3])

    with col1:
        if st.button("Cadastrar"):
            try:
                conexao_db = conexao.obter_conexao()
                cursor = conexao_db.cursor()
                

                comando = (
                    "INSERT INTO membro (nome, email, cargo) "
                    "VALUES (%s, %s, %s)"
                )
                
                valores = (nome, email, cargo)
                
                cursor.execute(comando, valores)
                
                conexao_db.commit()
                
                cursor.close()
                conexao_db.close()
                
                st.success('Membro cadastrado com sucesso!')
                    
            except Exception as erro:
                st.warning("Erro ao cadastrar! ERRO: " + erro)
    with col2: 
        if st.button("Fechar"):
            st.rerun()
            
@st.dialog("Cadastrar tarefa")
def cadastrar_tarefa():
    descricao = st.text_input("Descricao da tarefa: ")
    data_inicio= st.date_input("Data de Inicio:")
    status = st.selectbox("Status", ("Em andamento", "Atrasada", "Concluída"))
    id_projeto = st.number_input("ID do Projeto (Consulte abaixo):")
    
    if st.button("Consultar projetos"): 
        consultar_projetos()
        
    id_membro = st.number_input("ID do membro (Consulte Abaixo)",)
    
    if st.button("Consultar membros"): 
        consultar_membros()
    
    col1, col2, col3= st.columns([2, 2, 3])

    with col1:
        if st.button("Cadastrar"):
            try:
                conexao_db = conexao.obter_conexao()
                cursor = conexao_db.cursor()
                

                comando = (
                    "INSERT INTO tarefa (descricao, data_inicio, status, projeto_id_projeto, membro_id_membro) "
                    "VALUES (%s, %s, %s, %s, %s)"
                )
                
                valores = (descricao, data_inicio, status, id_projeto, id_membro)
                
                cursor.execute(comando, valores)
                
                conexao_db.commit()
                
                cursor.close()
                conexao_db.close()
                
                st.success('Tarefa cadastrado com sucesso!')
                    
            except Exception as erro:
                st.warning("Erro ao cadastrar. ERRO: ")
                st.warning(erro)
    with col2: 
        if st.button("Fechar"):
            st.rerun()



def consultar():
    try:
        conexao_db = conexao.obter_conexao()
        

        consulta = "SELECT nome FROM projeto"

        df = pd.read_sql(consulta, conexao_db)

        conexao_db.close()

        return df

    except Exception as erro:
        st.error(f"Erro ao consultar no banco: {erro}")

def consultar_projetos():
    try:
        conexao_db = conexao.obter_conexao()
        

        consulta = "SELECT * FROM projeto"

        df = pd.read_sql(consulta, conexao_db)

        conexao_db.close()

        if not df.empty:
            st.dataframe(df)
        else:
            st.warnig("Nenhum registro encotrando no banco.")

    except Exception as erro:
        st.error(f"Erro ao consultar no banco: {erro}")

def consultar_membros():
    try:
        conexao_db = conexao.obter_conexao()
        

        consulta = "SELECT * FROM membro"

        df = pd.read_sql(consulta, conexao_db)

        conexao_db.close()

        if not df.empty:
            st.dataframe(df)
        else:
            st.warnig("Nenhum registro encotrando no banco.")

    except Exception as erro:
        st.error(f"Erro ao consultar no banco: {erro}")
        
def consultar_tarefas():
    try:
        conexao_db = conexao.obter_conexao()
        

        consulta = "SELECT t.descricao AS Descricao, t.data_inicio AS Data_Inicio, t.data_fim AS Data_fim, status AS Status, p.nome AS Projeto, m.nome AS Membro, m.email AS Email, m.cargo AS CARGO FROM tarefa AS t INNER JOIN membro as m ON t.membro_id_membro = m.id_membro INNER JOIN projeto AS p ON t.projeto_id_projeto = p.id_projeto"

        df = pd.read_sql(consulta, conexao_db)

        conexao_db.close()

        if not df.empty:
            st.dataframe(df)
        else:
            st.warnig("Nenhum registro encotrando no banco.")

    except Exception as erro:
        st.error(f"Erro ao consultar no banco: {erro}")


def consultar_membrosprojeto(projeto):
    try:
        conexao_db = conexao.obter_conexao()         

        consulta = "SELECT id_projeto FROM projeto  WHERE nome = %s"                 
                            
        df = pd.read_sql(consulta,  conexao_db,     params=(projeto,))

        conexao_db.close()

        id_projeto = int(df.loc[0, "id_projeto"])

        conexao_db = conexao.obter_conexao()         

        consulta = "SELECT p.nome AS Projeto, m.nome AS Membro, m.email AS Email, m.cargo AS Cargo FROM tarefa AS t INNER JOIN membro as m ON t.membro_id_membro = m.id_membro INNER JOIN projeto AS p ON t.projeto_id_projeto = p.id_projeto WHERE p.id_projeto = %s"                 
                            
        df_membros = pd.read_sql(consulta,  conexao_db,     params=[id_projeto])
        conexao_db.close()

        if df_membros.empty:
            st.info("Nenhum membro associado a esse projeto.")
        else:
            st.dataframe(df_membros)

    except Exception as erro:
        st.error(f"Erro ao consultar no banco: {erro}")


# corpo da pagina
st.title("Gerenciador de Projetos")

st.subheader("Projetos cadastrados")

consultar_projetos()

if st.button("Cadastrar Projeto", key="button-cadastrar-projeto"):
    cadastrar_projeto()
    
st.subheader("Membros cadastrados")
consultar_membros()

if st.button("Cadastrar Membro", key="button-cadastrar-membro"):
    cadastrar_Membro()

st.subheader("Tarefas")
consultar_tarefas()

if st.button("Cadastrar Tarefa", key="button-cadastrar-tarefa"):
    cadastrar_tarefa()

st.subheader("Pesquisar membros por projeto")

col1, col2 = st.columns([3, 1])

opcao = st.selectbox("Selecione um projeto", consultar())

consultar_membrosprojeto(opcao)