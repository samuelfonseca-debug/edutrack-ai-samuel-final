import io
import csv

def main(inputs, context):
    subjects = inputs.get('subjects', [])
    tasks = inputs.get('tasks', [])
    
    # Criamos um dicionário para mapear o ID da disciplina ao seu nome facilmente
    subject_map = {s.get('id'): s.get('name', 'Sem Nome') for s in subjects}
    
    # 1. Gerando o CSV de Disciplinas
    subjects_output = io.StringIO()
    subjects_writer = csv.writer(subjects_output, delimiter=';')
    subjects_writer.writerow(['ID da Disciplina', 'Nome da Disciplina', 'Status'])
    
    for s in subjects:
        subjects_writer.writerow([
            s.get('id'),
            s.get('name'),
            s.get('status', 'active')
        ])
    
    # 2. Gerando o CSV de Tarefas
    tasks_output = io.StringIO()
    tasks_writer = csv.writer(tasks_output, delimiter=';')
    tasks_writer.writerow(['ID da Tarefa', 'Título', 'Disciplina', 'Data de Entrega', 'Concluída'])
    
    for t in tasks:
        sub_id = t.get('subject_id')
        sub_name = subject_map.get(sub_id, 'Não Associada')
        
        tasks_writer.writerow([
            t.get('id'),
            t.get('title'),
            sub_name,
            t.get('due_date'),
            'Sim' if t.get('completed', False) else 'Não'
        ])
        
    return {
        "filename_subjects": "export_disciplinas.csv",
        "csv_subjects_content": subjects_output.getvalue(),
        "filename_tasks": "export_tarefas.csv",
        "csv_tasks_content": tasks_output.getvalue()
    }