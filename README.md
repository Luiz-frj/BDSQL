##Feito por:
  - Luiz Francisco Rodrigues Junior
  - Guilherme Zappalenti Fragiacomo

# Introdução
O SmartMirrorFit é um sistema de gerenciamento para um espelho inteligente focado em fitness. Ele permite a compra de produtos e serviços, controle de assinaturas, gestão de estoque, fornecedores, pagamentos e funcionários. O objetivo é proporcionar uma experiência fluida para usuários e administradores, garantindo eficiência operacional.

# Requisitos Funcionais
  - O sistema deve permitir o cadastro, edição e exclusão de usuários.
  - Deve possibilitar a compra de produtos e serviços.
  - Deve gerenciar assinaturas de planos, incluindo criação, renovação e cancelamento.
  - O estoque dos produtos deve ser atualizado automaticamente após uma compra.
  - Deve permitir o gerenciamento de fornecedores e pedidos de compra.
  - Funcionários e cargos devem ser gerenciáveis pelo sistema.
  - Deve oferecer métodos de pagamento e registrar transações realizadas.
  - O sistema deve armazenar informações de localização do estoque.
  - Deve oferecer relatórios sobre vendas, assinaturas e estoques.
  - Deve permitir consulta de benefícios dos planos oferecidos.

# Requisitos Não Funcionais
  - O sistema deve utilizar Oracle SQL Developer para gerenciamento do banco de dados.
  - Deve garantir segurança nos dados, aplicando integridade referencial e triggers para validações.
  - O tempo de resposta para consultas não deve exceder 3 segundos.
  - Deve ser escalável para suportar um grande volume de usuários e transações.
  - A interface deve ser intuitiva e de fácil utilização.
  - Deve utilizar PL/SQL para automação de tarefas recorrentes.
  - O banco de dados deve suportar backup e recuperação de dados.
  - Deve permitir integração com outros serviços por meio de APIs.

## Modelo Entidade-Relacionamento (MER)
  - Usuário → Compra → Produto
    - Um usuário pode comprar vários produtos.
    - Um produto pode ser comprado por vários usuários.
    - Relacionamento: 1:N (Usuário → Compra) e N:1 (Compra → Produto).
  
  - Usuário → Assinatura → Plano
    - Um usuário pode ter uma assinatura ativa em um plano.
    - Um plano pode ser assinado por vários usuários.
    - Relacionamento: 1:N (Plano → Assinatura) e N:1 (Assinatura → Usuário).
  
  - Fornecedor → Produto
    - Um fornecedor pode fornecer vários produtos.
    - Um produto pode ter apenas um fornecedor principal.
    - Relacionamento: 1:N (Fornecedor → Produto).
  
  - Produto → Estoque
    - Cada produto tem uma quantidade controlada no estoque.
    - Relacionamento: 1:1 (Produto → Estoque).
    
  - Fornecedor → Pedido de Compra → Produto
    - Um fornecedor pode receber vários pedidos de compra.
    - Cada pedido pode incluir vários produtos.
    - Relacionamento: 1:N (Fornecedor → Pedido de Compra) e N:M (Pedido de Compra ↔ Produto) (Tabela intermediária necessária).
  
  - Usuário → Pagamento
    - Um usuário pode fazer vários pagamentos.
    - Cada pagamento pertence a um único usuário.
    - Relacionamento: 1:N (Usuário → Pagamento).
  
  - Funcionário → Cargo
    - Um funcionário pode ocupar apenas um cargo.
    - Um cargo pode ser ocupado por vários funcionários.
    - Relacionamento: 1:N (Cargo → Funcionário).
   
  - Localização → Estoque
    - Cada estoque pode estar em um local específico.
    - Relacionamento: 1:1 (Localização → Estoque).
   
  - Plano → Benefícios
    - Cada plano pode oferecer vários benefícios.
    - Relacionamento: 1:N (Plano → Benefícios).
