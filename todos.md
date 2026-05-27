# TO-DO Portal

Em ordem de urgência/importância.

## Dashboard

1. Revisar a tabela de variáveis
1.1. Transformar variáveis para entrar no Dashboard
1.2. Documentar transformações e manter as duas variáveis (e.g. Frota de táxi + Frota de táxi per capita)

* Exportar para Excel e classificar manualmente.
    * Apenas variáveis comparáveis entram no Dashboard.
    * Todas as variáveis que estejam suficientemente preenchidas entram na tabela.
* Importar no R para criar valores.

| code_muni | name_muni | abbrev_state | data: ano, label, valor, is_dashboard, is_scaled, valor_scaled, label_pergunta.

* Exportar para JSON no formato já especificado.

OBS: olhar especificamente para algumas variáveis problemáticas -> custos metrô tem um label de ônibus vazia com problema.

2. Revisão detalhada de todas funções do dashboard.

2.1. Formatação dos números na tabela PEMOB.
2.2. Nome dos labels (erros de português e consistência).
2.3. Botões (ativação/desativação)


## Catálogo de Dados

1. Adicionar texto de apoio para os labels (metadata no popup existente)
2. Lembrar de modificar o nome dos botões
3. Lembrar de ajustar as opções label (variando por cidade)
