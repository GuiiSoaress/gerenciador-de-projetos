#Procedure para cadastrar Projetos (nome, descricao, data inicio, data Fim)
CALL cadastrar_projeto
("FixNow", "Sistema de gerenciamento de solicitações de manutenção Empresarial", "2025-02-01", NULL, @saida, @rotulo);

#Procedure para cadastrar Membros (nome, email, cargo)
CALL 
	cadastrar_membro("Guilherme Soares", "guihhsoaress@gmail.com", "Lider", @saida, @rotulo);

#Procedure para cadastrar tarefas (descricao, data inicio, data fim, status, id Projeto, Id Membro)
CALL 
	cadastrar_tarefa("Criar Banco de dados", "2025-05-14", NULL, "Em andamento", 1, 1, @saida, @rotulo);
    

#Scripts para consulta: 

# Listar todos os membros de um projeto específico

SELECT
	m.nome AS Membro, 
    m.email AS Email, 
    p.nome AS Projeto 
FROM
	membro AS m
    INNER JOIN tarefa AS t ON t.membro_id_membro = m.id_membro
	INNER JOIN projeto AS p ON t.projeto_id_projeto = p.id_projeto
WHERE
	p.id_projeto = 1;
    
    
# Exibir todas as tarefas de um membro

SELECT
	m.nome AS Membro, 
    p.nome AS Projeto,
    t.descricao AS Tarefa,
    t.id_tarefa
FROM
	membro AS m
    INNER JOIN tarefa AS t ON t.membro_id_membro = m.id_membro
	INNER JOIN projeto AS p ON t.projeto_id_projeto = p.id_projeto
WHERE
	m.id_membro = 1;
    
    
# Verificar quais tarefas estão atrasadas.

SELECT
	m.nome AS Membro, 
    p.nome AS Projeto,
    t.descricao AS Tarefa,
    t.id_tarefa, 
    t.status AS Status
FROM
	membro AS m
    INNER JOIN tarefa AS t ON t.membro_id_membro = m.id_membro
	INNER JOIN projeto AS p ON t.projeto_id_projeto = p.id_projeto
WHERE
	t.status LIKE "Atrasada";
    


