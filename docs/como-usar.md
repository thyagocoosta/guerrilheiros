# Como usar o Guerrilheiros no dia a dia

## A rotina da squad

**De manhã.** Cada squad abre **Ações → + Nova ação** e lança o que vai produzir no dia. Título, frente, município, canal, responsável e com quem está. A meta é 15 conteúdos por dia para Águas de Teresina e Timon e a meta de cada macrorregião aparece no Painel.

Quem tem o quadro do dia em PPTX pula esse passo: **Relatórios → Importar o quadro do dia**, escolhe o arquivo e o sistema lê os slides, reconhece as regionais e grava tudo. Importar duas vezes o mesmo arquivo não duplica nada.

**Durante o dia.** A ação anda pelo kanban: em criação, em aprovação, concluída. Quando o material fica pronto, anexe a arte na própria ação, em JPEG, PNG ou PDF, até 20 MB. Vídeo entra pelo link do material.

**Na aprovação.** A coordenação abre a fila e clica na ação. Abre um resumo com tudo que interessa e o material na tela, sem precisar abrir link nenhum. Dali sai Liberar ou Devolver, e devolver pede o motivo.

**Depois de publicar.** Em **Repercussão**, lance alcance, interações e o sentimento. Isso alimenta o total por regional no Painel.

## Os relatórios

Em **Relatórios**:

- **PPT por regional** sai com a capa da regional, o mapa destacado, os cards da squad e a tabela do dia.
- **PPT geral** sai com a capa "Guerrilha de Comunicação" e a tabela de todas as regionais.
- **Quadro do dia** mostra a tabela na tela, com filtro de período.

Os atalhos de período (Hoje, 7 dias, Este mês, Mês passado, Tudo) valem em Painel, Ações, Repercussão e Relatórios.

## Quem vê o quê

| Perfil | Enxerga |
|---|---|
| Administrador | tudo, inclusive Configuração |
| Coordenação | tudo menos Configuração, e libera aprovações |
| Analista | Painel, Ações, Repercussão e Relatórios, só da squad dele |

Em **Configuração → Administração → Matriz de permissões** dá para mudar o que cada perfil vê no menu. E no cadastro de cada pessoa dá para marcar abas específicas, que valem acima do perfil.

## Configuração

**Cadastros.** Canais, fornecedores, tipos de conteúdo, veículos, marcas e usuários. Lista aberta: o que faltar, cadastre.

**Parâmetros.** Meta por regional, data da eleição, o que aparece no Painel.

**Administração.** Permissões, quadros dos cadastros, conexão com o Supabase, backup e o log de auditoria com os últimos 100 movimentos.

## Backup

**Configuração → Administração → Backup e restauração** baixa um JSON com tudo. Guarde um por semana enquanto o sistema estiver em `local`. Depois de ligar o Supabase, o backup vira só garantia extra.
