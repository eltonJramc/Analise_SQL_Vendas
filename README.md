# Análise de Dados com SQL

Este projeto utiliza SQL para realizar consultas, análises de séries temporais e geração de relatórios baseados em um banco de dados fictício com informações sobre 
vendas, produtos, categorias, fornecedores e clientes.

## 🚀 Funcionalidades

- **Consultas e visualização de dados**
  - Exibição inicial das tabelas e contagem de registros.
  - Análise unificada de contagens em todas as tabelas.

- **Análises temporais**
  - Total de vendas por ano.
  - Total de vendas por ano e mês.
  - Filtro de meses específicos (Janeiro, Novembro e Dezembro).

- **Análise de Black Friday**
  - Identificação do papel dos fornecedores.
  - Vendas por categorias de produtos.

- **Porcentagem e comparação**
  - Distribuição percentual das vendas por categorias.
  - Comparação de vendas na Black Friday de 2022 com a média dos anos anteriores.

## 🛠️ Tecnologias Utilizadas

- **SQL**: Linguagem principal utilizada para criar consultas e realizar análises.
- **SQLite**: Sistema de gerenciamento de banco de dados utilizado no projeto.

## 📂 Estrutura do Banco de Dados

O banco de dados é composto pelas seguintes tabelas principais:

1. **categorias**: Informações sobre as categorias dos produtos.
2. **clientes**: Dados dos clientes.
3. **fornecedores**: Detalhes sobre os fornecedores.
4. **itens_venda**: Produtos vendidos em cada venda.
5. **marcas**: Marcas dos produtos.
6. **produtos**: Informações sobre os produtos disponíveis.
7. **vendas**: Registros das vendas realizadas.
