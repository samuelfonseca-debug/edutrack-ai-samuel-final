# Proposta de artefato: calculate_progress

## Objetivo
Planejar a implementação de um script Python em `scripts/calculate_progress.py` que calcule a porcentagem de progresso com base em tarefas concluídas e total de tarefas, retornando o resultado em JSON.

## Escopo
- Definir a lógica de cálculo de progresso como `concluídas / total`.
- Tratar casos especiais como total igual a zero para evitar divisão por zero.
- Retornar um objeto JSON contendo a porcentagem de progresso.
- Garantir que o script aceite dados de entrada simples e produza um JSON válido.

## Proposta de implementação
- Criar `scripts/calculate_progress.py` como módulo Python independente.
- Incluir uma função `calculate_progress(completed, total)` que retorne um dicionário com a porcentagem de progresso.
- Serializar o resultado para JSON usando a biblioteca `json` do Python.
- Documentar formato de entrada e saída no próprio script.

## Impacto
- Fornece utilitário simples de cálculo de progresso para consumo interno ou integração com outras partes do app.
- Evita erros de cálculo ao tratar casos de total zero.
- Cria uma base reutilizável para mostrar progresso em relatórios ou dashboards.
