from datetime import datetime

def main(inputs, context):
    subjects = inputs.get('subjects', [])
    tasks = inputs.get('tasks', [])
    
    now = datetime.now()
    
    # 1. Total de disciplinas ativas (filtrando as que não estão inativas)
    total_subjects_active = len([s for s in subjects if s.get('status') != 'inactive'])
    
    # 2. Total de tarefas pendentes e em atraso
    pendentes = [t for t in tasks if not t.get('completed', False)]
    em_atraso = 0
    proximas_tarefas = []
    
    for t in pendentes:
        due_date_str = t.get('due_date')
        if due_date_str:
            try:
                # Tratamento simples para converter a data do banco
                due_date = datetime.fromisoformat(due_date_str.replace('Z', '+00:00'))
                if due_date.timestamp() < now.timestamp():
                    em_atraso += 1
                
                proximas_tarefas.append({
                    "id": t.get("id"),
                    "title": t.get("title"),
                    "due_date": due_date_str,
                    "subject_id": t.get("subject_id")
                })
            except:
                pass

    # Ordenar as próximas 5 tarefas com prazo mais próximo
    proximas_tarefas = sorted(proximas_tarefas, key=lambda x: x['due_date'])[:5]
    
    # 3. Indicador de progresso geral (percentual de tarefas concluídas)
    total_tasks = len(tasks)
    concluidas = total_tasks - len(pendentes)
    progresso_geral = round((concluidas / total_tasks) * 100, 2) if total_tasks > 0 else 0.0

    return {
        "total_subjects_active": total_subjects_active,
        "total_tasks_pending": len(pendentes),
        "total_tasks_overdue": em_atraso,
        "upcoming_tasks": proximas_tarefas,
        "general_progress_percentage": progresso_geral
    }