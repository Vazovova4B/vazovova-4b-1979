-- Vazovova 4.B 1979 - Supabase databaza - OPRAVENÉ 20.11.2026
-- ZMENA: stlpec 'STARÝ_NÁZOV' ZRUŠENÝ, nahradený stĺpcom 'vydatá'
-- U dievcat s 2 priezviskami: 1. priezvisko ostava v 'priezvisko' (za slobodna), 2. je v 'vydatá'
-- Priklad: Naďa Jelinková Liščáková -> priezvisko=Jelinková, vydatá=Liščáková
-- V Supabase: SQL Editor -> New query -> vloz cely tento subor -> Run

-- Ak uz mas staru tabulku s STARÝ_NÁZOV, najprv ju zmaz:
-- drop table if exists classmates cascade;

create table if not exists classmates (
  id uuid primary key default gen_random_uuid(),
  meno text not null,
  priezvisko text not null,
  "vydatá" text,
  datum_narodenia date,
  email text,
  telefon text,
  whatsapp text,
  facebook text,
  stav text default 'živý' check (stav in ('živý','už nežije')),
  opravnenie text default 'Štandard' check (opravnenie in ('Admin','Editor','Štandard')),
  sedenie_rad int,
  sedenie_miesto int,
  zaluby text,
  foto_vtedy_url text,
  foto_dnes_url text,
  privacy_email boolean default false,
  privacy_telefon boolean default false,
  privacy_datum boolean default true,
  zucastnil int default 0,
  nezucastnil int default 0,
  organizoval int default 0,
  created_at timestamptz default now()
);

create table if not exists events (id uuid primary key default gen_random_uuid(), datum date not null, cas time not null default '17:00', miesto text not null, gps text, popis text, typ text default 'stretnutie', created_by uuid, created_at timestamptz default now());
create table if not exists history (id uuid primary key default gen_random_uuid(), datum date not null, miesto text, popis text, created_by uuid, created_at timestamptz default now());
create table if not exists photos (id uuid primary key default gen_random_uuid(), album text, drive_url text, popis text, autor text, created_at timestamptz default now());
create table if not exists messages (id uuid primary key default gen_random_uuid(), komu text, predmet text, telo text, odosielatel text, created_at timestamptz default now());
create table if not exists votes (id uuid primary key default gen_random_uuid(), navrh text, hlasy_za int default 0, hlasy_proti int default 0, stav text default 'V hlasovaní');

alter table classmates enable row level security;
alter table events enable row level security;
alter table history enable row level security;
alter table photos enable row level security;
alter table messages enable row level security;
alter table votes enable row level security;
create policy "read all" on classmates for select using (true);
create policy "read all" on events for select using (true);
create policy "read all" on history for select using (true);
create policy "read all" on photos for select using (true);
create policy "read all" on messages for select using (true);
create policy "read all" on votes for select using (true);

-- 37 spolužiakov
insert into classmates (meno, priezvisko, "vydatá", sedenie_rad, sedenie_miesto, stav, opravnenie) values
('Ľudo','Ivaško','',1,1,'už nežije','Štandard'),
('Peter','Plavčan','',1,2,'živý','Štandard'),
('Peter','Sobotka','',1,3,'živý','Štandard'),
('Boris','Muroň','',1,4,'živý','Štandard'),
('Braňo','Koštial','',1,5,'živý','Štandard'),
('Fedor','Roll','',1,6,'živý','Štandard'),
('Viera','Setnická','',2,1,'živý','Štandard'),
('Naďa','Jelinková','Liščáková',2,2,'živý','Štandard'),
('Juraj','Ferianc','',2,3,'živý','Admin'),
('Boris','Topoľský','',2,4,'už nežije','Štandard'),
('Igor','Matečný','',2,5,'živý','Štandard'),
('Daniel','Jaura','',2,6,'živý','Štandard'),
('Viera','Jašková','Michalcová',3,1,'živý','Štandard'),
('Alena','Makovická','Kozaková',3,2,'živý','Štandard'),
('Marian','Rafaj','',3,3,'živý','Štandard'),
('Peter','Manca','',3,4,'živý','Štandard'),
('Ľubomír','Piktor','',3,5,'živý','Štandard'),
('Róbert','Rudinský','',3,6,'živý','Štandard'),
('Ľuba','Gajdošová','Bortlíková',4,1,'živý','Štandard'),
('Ľuba','Fekiačová','Kročanová',4,2,'živý','Štandard'),
('Vladimír','Čachan','',4,3,'živý','Štandard'),
('Tibor','Brauner','',4,4,'živý','Štandard'),
('Stano','Horáček','',4,5,'živý','Štandard'),
('Milan','Kříž','',4,6,'živý','Štandard'),
('Jana','Cibulková','Krajmerová',5,1,'živý','Štandard'),
('Ingrid','Holkovičová','Potisková',5,2,'živý','Štandard'),
('Milena','Heliková','Marušicová',5,3,'živý','Štandard'),
('Lýdia','Ranková','Šuchová',5,4,'živý','Štandard'),
('Robert','Baumgartner','',5,6,'živý','Štandard'),
('Ľuba','Vallová','',6,2,'živý','Štandard'),
('Ľudmila','Bursiková','Chlebová',6,3,'živý','Štandard'),
('Jana','Komanová','Gáliková',6,6,'živý','Štandard'),
('Jana','Danielová','',6,7,'už nežije','Štandard'),
('Soňa','Dašková','',7,1,'živý','Štandard'),
('Danka','Pešlová','Breyerová',7,2,'živý','Štandard'),
('Alena','Plevková','',null,null,'živý','Štandard'),
('Táňa','Gbelcová','Jurgová',null,null,'živý','Štandard');

insert into events (datum, cas, miesto, popis) values ('2027-06-20','17:00','Reštaurácia Leberfinger, Bratislava','Letné stretnutie 4.B'), ('2027-09-12','10:00','Výlet Devín','Výlet'), ('2026-11-13','17:00','Stretávka, Bratislava','Stretávka - fotky v albume 13.11.2026');

-- ===== RLS PRE PRIHLASENIE / REGISTRACIU (nova verzia odznovu) =====
-- Citanie: vsetci. Zapis: len prihlaseni. Bez tohto by registracia a ukladanie padali na RLS.
-- Spusti sa bezpecne aj opakovane.
drop policy if exists "allow insert authenticated" on classmates;
drop policy if exists "allow update authenticated" on classmates;
drop policy if exists "allow insert authenticated" on events;
drop policy if exists "allow insert authenticated" on history;
drop policy if exists "allow insert authenticated" on photos;
drop policy if exists "allow insert authenticated" on messages;
create policy "allow insert authenticated" on classmates for insert to authenticated with check (true);
create policy "allow update authenticated" on classmates for update to authenticated using (true) with check (true);
create policy "allow insert authenticated" on events for insert to authenticated with check (true);
create policy "allow insert authenticated" on history for insert to authenticated with check (true);
create policy "allow insert authenticated" on photos for insert to authenticated with check (true);
create policy "allow insert authenticated" on messages for insert to authenticated with check (true);
