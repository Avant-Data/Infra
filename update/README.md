# Atualização do AvantData

## Descrição

Este repositório contém scripts para atualizar e criar um pacote (bundle) do AvantData.

## Arquivos

### 1. create_bundle_avantdata.py

Este script é usado para criar um pacote (bundle) para o AvantData. Ele realiza as seguintes ações:
- Define o caminho do AvantData e o nome do commit.
- Define uma função para executar comandos de shell.
- Gera um arquivo .gitignore com o conteúdo especificado.
- Inicializa um repositório Git.
- Adiciona todos os arquivos ao repositório.
- Faz commit das alterações com o nome do commit especificado.
- Remove o pacote existente.
- Cria um novo pacote no local especificado.

### 2. update_avantdata.py

Este script é usado para atualizar o AvantData. Ele realiza as seguintes ações:
- Define o caminho do AvantData e o nome do commit.
- Define uma função para executar comandos de shell.
- Gera um arquivo .gitignore com o conteúdo especificado.
- Inicializa um repositório Git.
- Adiciona todos os arquivos ao repositório.
- Faz commit das alterações com o nome do commit especificado.
- Busca as alterações de um pacote (bundle).
- Mescla as alterações buscadas no repositório.
- Desfaz o checkout dos arquivos mesclados.
- Adiciona os arquivos mesclados ao repositório.
- Faz commit das alterações mescladas com o nome do commit especificado.
- Altera a propriedade (ownership) do repositório para as do Apache.

