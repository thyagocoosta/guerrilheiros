# Guerrilheiros · GCA

Sistema de gestão das squads regionais de Comunicação da Aegea no Piauí. Produção, aprovação e repercussão das ações diárias em um lugar só, até a eleição de 04/10/2026.

O sistema é **um arquivo só**, o `index.html`. Não tem build, não tem npm, não tem biblioteca externa. Abrir o arquivo já é usar o sistema.

## O que tem dentro

| Aba | Para que serve |
|---|---|
| Painel | números do dia, meta por regional, mapa do Piauí |
| Ações | lista, kanban e mapa das ações de cada squad |
| Aprovações | fila da coordenação, com o material anexado na tela |
| Repercussão | alcance, interações e sentimento de cada publicação |
| Relatórios | quadro do dia, PPT por regional e PPT geral |
| Squads | as seis squads, metas e responsáveis |
| Configuração | cadastros, parâmetros e administração |

Também importa o **Quadro do Dia** em PPTX: o sistema lê os slides, reconhece as regionais e grava as ações sem duplicar.

## Subir na Vercel

1. Suba esta pasta para um repositório no GitHub.
2. Na Vercel, **Add New → Project**, escolha o repositório e clique em **Deploy**. Não mexa em nada: o `vercel.json` já diz que é site estático.
3. Abra o endereço, entre no sistema e vá em **Configuração → Administração → Identidade e conexão** para ligar o Supabase.

O passo a passo completo, com o SQL e as políticas de acesso, está em [`docs/vercel-e-supabase.md`](docs/vercel-e-supabase.md). O SQL pronto para colar está em [`supabase/schema.sql`](supabase/schema.sql).

## Configuração

As três linhas que importam ficam no topo do `index.html`, dentro do quadro `GUERRILHEIROS · CONFIGURAÇÃO`:

```js
backend: 'local',        // 'local' | 'supabase' | 'dataverse'
supabase: {
  url:  '',              // https://xxxxxxxx.supabase.co
  anon: ''               // chave anon (publishable)
}
```

Dá para fazer isso pela tela também, sem abrir o arquivo. O que for salvo pela tela fica gravado no navegador e tem prioridade sobre o que está escrito aqui.

## Primeiro acesso

Entre com o e-mail Aegea cadastrado. Os usuários já vêm pré-carregados: diretoria, gerência, coordenações, analistas e as contas de área do B-R-O BRÓ.

Depois do primeiro acesso, troque as senhas em **Configuração → Cadastros → Usuários**.

## Pastas

```
index.html                     o sistema
vercel.json                    configuração do deploy
supabase/schema.sql            tabela e políticas
docs/vercel-e-supabase.md      passo a passo do deploy
modelos/                       planilha das squads e exemplo do PPT gerado
```

## Dados

Em `local`, tudo fica no navegador de quem abre, e os anexos vão para o IndexedDB. Em `supabase`, cada registro vira uma linha da tabela `gca_registros`, com o conteúdo em `jsonb`. Trocar de um para o outro não exige mexer no resto do arquivo.

Backup e restauração ficam em **Configuração → Administração**.

---

Sistema by TC · Comunicação Aegea Piauí
