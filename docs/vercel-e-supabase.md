# Guerrilheiros na Vercel com Supabase · passo a passo

O sistema é um arquivo só (`GCA_Guerrilheiros.html`), sem biblioteca externa. Ele já roda hoje guardando tudo no navegador de quem abre. Para virar sistema de verdade, com a mesma base para todo mundo, o que muda é só a camada de dados: as coleções passam a viver em uma tabela do Supabase e o arquivo vai para a Vercel.

## 1. Criar o projeto no Supabase

1. Em supabase.com, **New project**. Escolha a região **South America (São Paulo)**, que fica mais perto do time.
2. Guarde a senha do banco.
3. Em **Project Settings → API**, anote **Project URL** e a chave **anon / publishable**.

## 2. Criar a tabela

Em **SQL Editor**, rode isto:

```sql
create table if not exists gca_registros (
  id            text primary key,
  colecao       text not null,
  dados         jsonb not null,
  atualizado_em timestamptz not null default now()
);

create index if not exists gca_registros_colecao on gca_registros (colecao);

alter table gca_registros enable row level security;
```

Uma tabela só, três colunas. Cada registro do sistema (uma ação, uma pessoa, uma squad) vira uma linha com o JSON em `dados`. Isso evita criar dezenas de colunas e deixa o schema parado quando um campo novo aparecer.

## 3. Escolher quem pode ler e gravar

**Opção A · começar simples (recomendada para o piloto).** Quem tiver o endereço do site usa o sistema, e a entrada continua sendo a tela de login do próprio sistema:

```sql
create policy "gca leitura" on gca_registros
  for select using (true);

create policy "gca escrita" on gca_registros
  for all using (true) with check (true);
```

**Opção B · fechar por login do Supabase.** Se quiser exigir conta antes de qualquer leitura, troque as duas políticas acima por:

```sql
create policy "gca autenticado" on gca_registros
  for all to authenticated using (true) with check (true);
```

Nesse caso, cadastre as pessoas em **Authentication → Users** com o e-mail Aegea delas. A anon key é pública por desenho: quem manda de verdade são estas políticas.

## 4. Ligar o Supabase

**Pela tela, sem abrir o arquivo (mais fácil).** Entre no sistema e vá em **Configuração → Administração → Identidade e conexão**. Escolha "Supabase (site na Vercel)", cole a URL do projeto e a chave anon, clique em **Testar a conexão** e depois em **Salvar e recarregar**. Pronto.

**Pelo arquivo.** A configuração é a primeira coisa do `GCA_Guerrilheiros.html`, nas primeiras linhas, dentro de um quadro marcado `GUERRILHEIROS · CONFIGURAÇÃO`:

```js
backend: 'local',   →   backend: 'supabase',

supabase: {
  url:  'https://xxxxxxxx.supabase.co',
  anon: 'sua-chave-anon',
  tabela: 'gca_registros'
}
```

O que for salvo pela tela manda em cima do que está no arquivo.

Na primeira abertura com `supabase`, o sistema encontra a tabela vazia e monta sozinho a base inicial: as seis squads, as pessoas, os cadastros e os usuários. As ações começam zeradas.

## 5. Publicar na Vercel

1. Crie uma pasta com o arquivo dentro, renomeado para `index.html`.
2. Na Vercel, **Add New → Project → Deploy**, arraste a pasta (ou suba num repositório e conecte).
3. Não precisa de framework, build nem `vercel.json`. É site estático.
4. Publique e guarde o endereço.

Se preferir não deixar a URL e a chave dentro do arquivo, dá para injetar no build com variável de ambiente. Para um site estático simples, deixar no arquivo resolve, já que a anon key não é segredo.

## 6. Domínio e acesso

Em **Settings → Domains** dá para apontar um subdomínio da Aegea. Se a área de TI pedir, a Vercel também tem **Deployment Protection** por senha ou por login, que fecha o site inteiro antes mesmo da tela do sistema.

## 7. Login e acesso de cada pessoa

A tela de entrada pede o e-mail Aegea e a senha. Cada pessoa nasce com a senha `aegea2026` e a coordenação ajusta tudo na aba **Configuração → Usuários**. Quem prefere digitar menos entra só com o nome curto (`thyago`, `marta`).

Já vêm cadastrados, com o mesmo acesso da Julia: **Lucilaine Medeiros**, **Rodrigo Lacerda**, **Julia Pessoa Gomes**, **Cloves Fernandes da Costa**, **Pedro Lima Pinto Santiago** e **Silvana Pereira de Sousa**. Confira os e-mails, que vieram no padrão `nome.sobrenome@aegea.com.br`.

No cadastro de cada usuário dá para definir:

- **Perfil**: Administrador, Coordenação ou Analista, que já traz um pacote de abas pronto.
- **Squad**: trava o analista na regional dele. Ele só enxerga as ações da própria squad em todas as telas.
- **Abas que a pessoa vê**: marcação individual. Deixando tudo desmarcado, vale o perfil; marcando, vale a lista dela.

Em **Configuração → Administração** ficam a **matriz de permissões** (o que cada perfil vê no menu), os **quadros dos Cadastros** (o que cada perfil vê dentro da aba Cadastros), a identidade, a conexão, o backup e o log de auditoria.

Já vêm cadastradas também as contas de área que existiam no sistema do BRO BRÓ: Coordenação Geral, Coordenação de Operação, Comunicação e Equipe de Campo.

## 8. Quadro do dia em PowerPoint

Na aba **Relatórios** existem três botões:

- **Geral, todas as regionais**: um arquivo com o resumo de todas e a tabela de cada uma.
- **Um arquivo por regional**: gera um PowerPoint separado para cada squad que teve conteúdo no período.
- **Só dessa regional**: escolhe a squad na lista ao lado.

O arquivo sai no padrão da marca, com capa, resumo e a tabela **# · Frente · Conteúdo · Município · Situação · Está com quem**, mais uma página de repercussão quando houver. O período é o dos filtros do topo: clique em **Hoje** para o quadro de um dia só.

O PowerPoint é montado dentro do próprio navegador, sem enviar nada para fora e sem depender de biblioteca externa.

## 9. Importar o quadro do dia

Na aba **Ações** e na aba **Relatórios** existe o botão **Importar quadro do dia**. Escolhe o PowerPoint preenchido e o sistema lê as tabelas dos slides, identifica a regional pelo título e transforma cada linha em ação.

O sistema entende estas colunas, com ou sem acento, em qualquer ordem: **Pauta** ou **Frente**, **Conteúdo**, **Município**, **Canal**, **Responsável**, **Está com quem**, **Situação**, **Data** e **Observação**.

As situações são traduzidas sozinhas: Planejado vira Criação; Em produção, Produzindo, Gravado e Em andamento viram Em produção; Pronto, Aguardando e Já solicitado viram Em aprovação; OK, Concluído, Publicado, Feito e Entregue viram Concluído; Parado e Suspenso viram Stand-by.

Antes de gravar, o sistema mostra a prévia com tudo o que leu e quantas linhas vieram de cada regional. Linha que já existe (mesma regional, mesma data e mesmo conteúdo) é atualizada, não duplicada, então dá para importar todo dia sem medo.

Canal que ainda não existe é cadastrado na hora. Responsável é procurado pelo nome na lista de pessoas.

## 10. Material para aprovar

Na aba **Aprovações**, clicar na ação abre o resumo: frente, regional, responsável, está com quem, tipo, município, canais, marca, observações e o **material anexado** já aberto na tela. Imagem, vídeo, áudio ou PDF, até 20 MB por arquivo. A coordenação vê, entende e clica em Liberar ou Devolver ali mesmo.

Anexo aceita **JPEG, PNG e PDF** até 20 MB. **Vídeo não anexa**: sobe no SharePoint e o link vai no campo Link do material. Imagem grande é reduzida sozinha antes de guardar, e no modo navegador os anexos ficam no IndexedDB, fora do armazenamento comum. Dá para anexar já no cadastro da ação, antes mesmo de salvar.

## 11. Vídeo e material pesado

O sistema guarda **o link**, não o arquivo. O vídeo continua no SharePoint ou no OneDrive, onde cada pessoa já tem 1 TB, e o campo **Link do material** aponta para lá. Assim o Supabase fica só com texto e nunca encosta no limite de armazenamento do plano gratuito (500 MB de banco).

## Checklist de subida

- [ ] Projeto criado no Supabase, região São Paulo
- [ ] Tabela `gca_registros` criada com o SQL acima
- [ ] Políticas de RLS escolhidas (opção A ou B)
- [ ] `CFG.backend` em `'supabase'`, com url e anon key preenchidas
- [ ] Arquivo renomeado para `index.html` e publicado na Vercel
- [ ] Primeiro acesso: conferir se as squads e as pessoas apareceram sozinhas
- [ ] Usuários revisados, com e-mail, perfil, squad e abas certas
- [ ] Um teste real: importar o quadro do dia, mover no kanban, anexar material, liberar e baixar o PowerPoint

## O que o sistema tem

**Sete abas.** Painel · Ações (lista, kanban e mapa na mesma tela) · Aprovações · Repercussão · Relatórios · Squads · Configuração (Cadastros, Parâmetros e Administração, no mesmo desenho do sistema do BRO BRÓ). O menu recolhe no botão do canto e fica só com os ícones. Abre sempre no tema claro.

**Ação.** Título, frente, está com quem, squad, responsável, tipo, marca, município, canais, status, link e observações, mais o material anexado. As datas ficam num bloco separado. Não existe mais SLA nem controle de tamanho de arquivo.

**Kanban.** Criação · Em produção · Em aprovação · Concluído · Stand-by, com arrastar e soltar. Concluído já quer dizer aprovado, e quem move para lá é a coordenação.

**Repercussão.** Ação que gerou, frente, município, veículo, tipo, alcance, interações, compartilhamentos, tom, quem abriu a porta e link. Escolhendo a ação, a squad, a frente e o município vêm preenchidos.

**Painel.** Filtro de período com atalhos (hoje, ontem, 7 dias, 30 dias, este mês, mês passado, tudo ou datas escolhidas), régua diária, mapa clicável com os 225 municípios, total por regional e mapa de calor por analista.

**Relatórios.** Recortes por período, squad, analista, tipo e marca, exportação em CSV e o quadro do dia em PowerPoint.

**Cada squad vê só a dela.** Analista enxerga apenas as ações da própria regional em todas as telas. Administrador e Coordenação enxergam as seis.

## Se a TI preferir o Power Pages

O adaptador do Dataverse continua no arquivo. Basta trocar `CFG.backend` para `'dataverse'` e conferir os nomes das tabelas em `CFG.dataverse`. As duas portas convivem; muda uma linha.
