from datetime import datetime

def main(inputs, context):
    tasks = inputs.get('tasks', [])
    now = datetime.now()
    
    atrasadas = []
    
    for t in tasks:
        # Se já foi concluída, não está atrasada
        if t.get('completed') or t.get('status') == 'completed':
            continue
            
        due_date_str = t.get('due_date')
        if due_date_str:
            try:
                # Converte a data string ISO do banco para objeto datetime
                due_date = datetime.fromisoformat(due_date_str.replace('Z', '+00:00'))
                
                # Se a data de vencimento é MENOR do que AGORA, a tarefa está atrasada!
                if due_date.timestamp() < now.timestamp():
                    atrasadas.append({
                        "id": t.get("id"),
                        "title": t.get("title"),
                        "due_date": due_date_str,
                        "prioridade": t.get("prioridade", "Média"),
                        "subject_id": t.get("subject_id")
                    })
            except:
                pass
                
    return {
        "overdue_count": len(atrasadas),
        "overdue_tasks": atrasadas
    }