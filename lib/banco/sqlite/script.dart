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

final criarTabelas = [_fabricante, _tipoManutencao];

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
