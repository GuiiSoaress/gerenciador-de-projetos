
import mysql.connector 

def obter_conexao():
    
    conexao = mysql.connector.connect(
        host="localhost",
        user="root",
        password="182022",
        database="gerenciamento_projetos"
    )

    return conexao
