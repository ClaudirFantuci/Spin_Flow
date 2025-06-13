final _fabricante = '''
CREATE TABLE fabricante (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    nome_contato_principal TEXT,
    email_contato TEXT,
    telefone_contato TEXT,
    ativo INTEGER NOT NULL DEFAULT 1
);
''';

final _tipoManutencao = '''
CREATE TABLE tipo_manutencao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    ativo INTEGER NOT NULL DEFAULT 1
);
''';

final _aluno = '''
CREATE TABLE aluno (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL,
    data_nascimento TEXT NOT NULL,
    genero TEXT NOT NULL,
    telefone_contato TEXT NOT NULL,
    perfil_instagram TEXT,
    perfil_facebook TEXT,
    perfil_tiktok TEXT,
    ativo INTEGER NOT NULL DEFAULT 1
);
''';

final _sala = '''
CREATE TABLE sala (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    capacidade_total_bikes INTEGER NOT NULL,
    numero_filas INTEGER NOT NULL,
    numero_bikes_por_fila INTEGER NOT NULL,
    ativo INTEGER NOT NULL DEFAULT 1
);
''';

final criarTabelas = [_fabricante, _tipoManutencao, _aluno, _sala];

final insertFabricantes = [
  '''
INSERT INTO fabricante (nome, descricao, nome_contato_principal, email_contato, telefone_contato, ativo) VALUES
    ('SpinTech', 'Fabricante de varas de spinning de alta performance', 'João Silva', 'joao@spintech.com', '(44) 99999-1111', 1),
    ('AquaSpin', 'Especializada em molinetes para spinning', 'Maria Santos', 'maria@aquaspin.com', '(21) 98888-2222', 1),
    ('WaveMaster', 'Equipamentos de spinning para pesca oceânica', 'Carlos Almeida', 'carlos@wavemaster.com', '(31) 97777-3333', 0),
    ('ProSpin', 'Linha completa de acessórios para spinning', 'Ana Costa', 'ana@prospin.com', '(11) 96666-4444', 1),
    ('ReelCraft', 'Fabricante de carretilhas premium para spinning', 'Pedro Lima', 'pedro@reelcraft.com', '(51) 95555-5555', 1);
'''
];

final insertTipoManutencao = [
  '''
INSERT INTO tipo_manutencao (nome, descricao, ativo) VALUES
    ('Preventiva', 'Manutenção preventiva para equipamentos', 1),
    ('Corretiva', 'Manutenção para corrigir falhas', 1),
    ('Preditiva', 'Manutenção baseada em análise preditiva', 0);
'''
];

final insertAlunos = [
  '''
INSERT INTO aluno (nome, email, data_nascimento, genero, telefone_contato, perfil_instagram, perfil_facebook, perfil_tiktok, ativo) VALUES
    ('Ana Pereira', 'ana.pereira@email.com', '1995-03-15', 'Feminino', '(11) 91234-5678', '@anapereira', 'ana.pereira.fb', '@anap.tiktok', 1),
    ('Bruno Costa', 'bruno.costa@email.com', '1998-07-22', 'Masculino', '(21) 98765-4321', null, null, null, 1),
    ('Clara Souza', 'clara.souza@email.com', '2000-11-30', 'Feminino', '(31) 99876-5432', '@clarasouza', null, null, 0);
'''
];

final insertSalas = [
  '''
INSERT INTO sala (nome, capacidade_total_bikes, numero_filas, numero_bikes_por_fila, ativo) VALUES
    ('Sala A', 20, 4, 5, 1),
    ('Sala B', 15, 3, 5, 1),
    ('Sala C', 10, 2, 5, 0);
'''
];
