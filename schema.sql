create table public.alunos (
  aluno_id serial not null,
  nome character varying(255) null,
  email character varying(255) not null,
  data_nascimento date null,
  nivel_ingles character varying(50) null,
  data_criacao_conta timestamp without time zone null default now(),
  ultimo_acesso timestamp without time zone null,
  user_id uuid not null,
  constraint alunos_pkey primary key (aluno_id),
  constraint alunos_email_key unique (email),
  constraint alunos_user_id_key unique (user_id)
) TABLESPACE pg_default;

create table public.catalogo (
  id_filmeserie serial not null,
  nome character varying(255) not null,
  genero character varying(100) null,
  duracao integer null,
  idioma_original character varying(50) null,
  link_streaming character varying(255) null,
  data_lancamento date null,
  classificacao_indicativa character varying(20) null,
  nota numeric(3, 1) null,
  sinopse text null,
  constraint catalogo_pkey primary key (id_filmeserie)
) TABLESPACE pg_default;

create table public.indicacoes (
  id_indicacao serial not null,
  aluno_id integer null,
  id_filme_serie integer null,
  data_indicacao date null default CURRENT_DATE,
  assistido boolean null default false,
  nota_indicacao numeric(3, 1) null,
  nota_conteudo numeric(3, 1) null,
  sinopse text null,
  constraint indicacoes_pkey primary key (id_indicacao),
  constraint indicacoes_aluno_id_fkey foreign KEY (aluno_id) references alunos (aluno_id) on delete CASCADE,
  constraint indicacoes_id_filme_serie_fkey foreign KEY (id_filme_serie) references catalogo (id_filmeserie) on delete CASCADE
) TABLESPACE pg_default;

create table public.preferencias (
  pref_id serial not null,
  aluno_id integer null,
  genero_1 character varying(100) null,
  genero_2 character varying(100) null,
  genero_3 character varying(100) null,
  idioma_preferido character varying(50) null,
  tipo_midia character varying(50) null,
  constraint preferencias_pkey primary key (pref_id),
  constraint preferencias_aluno_id_fkey foreign KEY (aluno_id) references alunos (aluno_id) on delete CASCADE
) TABLESPACE pg_default;



begin
  insert into public.alunos (user_id, email)
  values (new.id, new.email);
  return new;
end;



alter policy "alunos_insert"
on "public"."alunos"
to authenticated
with check (
(auth.uid() = user_id)
);


alter policy "alunos_select"
on "public"."alunos"
to authenticated
using (
 (auth.uid() = user_id)
);

CREATE TRIGGER alunos_insert
AFTER INSERT ON auth.users
FOR EACH ROW EXECUTE PROCEDURE public.alunos_insert();