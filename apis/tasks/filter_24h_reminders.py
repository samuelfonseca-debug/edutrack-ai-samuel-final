from datetime import datetime, timedelta

def main(inputs, context):
    tasks = inputs.get('tasks', [])
    
    now = datetime.now()
    amanha = now + timedelta(days=1)
    
    tarefas_urgentes = []
    
    for t in tasks:
        # Se a tarefa já foi marcada como concluída, pula
        if t.get('completed') or t.get('status') == 'completed':
            continue
            
        due_date_str = t.get('due_date')
        if due_date_str:
            try:
                # Converte a data string ISO do banco para objeto datetime
                due_date = datetime.fromisoformat(due_date_str.replace('Z', '+00:00'))
                
                # Se o vencimento está entre AGORA e as próximas 24 horas
                if now.timestamp() <= due_date.timestamp() <= amanha.timestamp():
                    tarefas_urgentes.append({
                        "id": t.get("id"),
                        "title": t.get("title"),
                        "due_date": due_date_str,
                        "prioridade": t.get("prioridade", "Média"),
                        "subject_id": t.get("subject_id")
                    })
            except:
                pass
                
    return {
        "alert_count": len(tarefas_urgentes),
        "urgent_tasks": tarefas_urgentes
    }