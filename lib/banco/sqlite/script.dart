final _fabricante = '''
CREATE TABLE fabricante (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- ID auto-incrementável para compatibilidade com sqflite
    nome TEXT NOT NULL, -- Nome do fabricante, obrigatório
    descricao TEXT, -- Descrição opcional
    nome_contato_principal TEXT, -- Nome do contato principal, opcional
    email_contato TEXT, -- Email do contato, opcional
    telefone_contato TEXT, -- Telefone com máscara (XX) 9XXXX-XXXX, opcional
    ativo INTEGER NOT NULL DEFAULT 1 -- Status ativo/inativo (1 para true, 0 para false)
);
''';

final criarTabelas = [_fabricante];

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
