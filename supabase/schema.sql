-- ===========================================================================
--  GUERRILHEIROS · GCA
--  Tabela única do sistema. Rode no SQL Editor do Supabase.
-- ===========================================================================

create table if not exists gca_registros (
  id            text primary key,
  colecao       text not null,
  dados         jsonb not null,
  atualizado_em timestamptz not null default now()
);

create index if not exists gca_registros_colecao on gca_registros (colecao);

alter table gca_registros enable row level security;

-- ---------------------------------------------------------------------------
--  OPÇÃO A · piloto. Quem tiver o endereço do site usa o sistema, e a entrada
--  continua sendo a tela de login do próprio sistema. Deixe estas duas.
-- ---------------------------------------------------------------------------

drop policy if exists "gca leitura" on gca_registros;
create policy "gca leitura" on gca_registros
  for select using (true);

drop policy if exists "gca escrita" on gca_registros;
create policy "gca escrita" on gca_registros
  for all using (true) with check (true);

-- ---------------------------------------------------------------------------
--  OPÇÃO B · fechado por login do Supabase. Para usar esta, apague as duas
--  políticas acima e tire o comentário da de baixo. Cadastre as pessoas em
--  Authentication -> Users com o e-mail Aegea.
--
--  A anon key é pública por desenho. Quem manda de verdade são estas políticas.
-- ---------------------------------------------------------------------------

-- drop policy if exists "gca leitura" on gca_registros;
-- drop policy if exists "gca escrita" on gca_registros;
-- create policy "gca autenticado" on gca_registros
--   for all to authenticated using (true) with check (true);

-- ---------------------------------------------------------------------------
--  Carimbo automático de atualização
-- ---------------------------------------------------------------------------

create or replace function gca_toca_atualizado()
returns trigger language plpgsql as $$
begin
  new.atualizado_em = now();
  return new;
end $$;

drop trigger if exists gca_registros_toca on gca_registros;
create trigger gca_registros_toca
  before update on gca_registros
  for each row execute function gca_toca_atualizado();

-- ===========================================================================
--  PRATELEIRA DOS ANEXOS
--  O arquivo anexado vai para o Storage, que é uma cota separada (1 GB no
--  plano grátis). No banco (500 MB) fica só a ficha do anexo com o caminho.
--  Sem isto o arquivo era convertido em texto e guardado dentro do banco,
--  engordando cerca de um terço e comendo a cota errada.
-- ===========================================================================

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('gca-anexos', 'gca-anexos', true, 20971520,
        array['image/png','image/jpeg','image/jpg','application/pdf'])
on conflict (id) do update
  set public             = excluded.public,
      file_size_limit    = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- Mesmo modo piloto da tabela: quem tem o endereço do sistema usa o material.
drop policy if exists "gca anexos leitura" on storage.objects;
create policy "gca anexos leitura" on storage.objects
  for select using (bucket_id = 'gca-anexos');

drop policy if exists "gca anexos envio" on storage.objects;
create policy "gca anexos envio" on storage.objects
  for insert with check (bucket_id = 'gca-anexos');

drop policy if exists "gca anexos troca" on storage.objects;
create policy "gca anexos troca" on storage.objects
  for update using (bucket_id = 'gca-anexos') with check (bucket_id = 'gca-anexos');

drop policy if exists "gca anexos exclusao" on storage.objects;
create policy "gca anexos exclusao" on storage.objects
  for delete using (bucket_id = 'gca-anexos');
