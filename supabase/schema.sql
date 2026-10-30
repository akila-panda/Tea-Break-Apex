-- Tea Break Apex: run once in Supabase → SQL Editor → New query → Run

-- Team members
create table people (
  id serial primary key,
  name text unique not null,
  photo_url text,
  active boolean not null default true
);

insert into people (name) values
  ('Akila'),('Amila'),('Asanka'),('Ashir'),('Ashvitha'),('Denura'),
  ('Dilhani'),('Sadath'),('Shayan'),('Vidura'),('Vishwa'),('Yashodara');

-- One row per person per day; guest orders get their own row (guest_name filled in)
create table orders (
  id bigint generated always as identity primary key,
  person_id int not null references people(id),
  day date not null,
  guest_name text not null default '',
  drinks jsonb not null default '{}',
  updated_at timestamptz not null default now(),
  unique (person_id, day, guest_name)
);

-- Open access for the publishable key (no-login office app)
alter table people enable row level security;
alter table orders enable row level security;
create policy "read people"   on people for select to anon using (true);
create policy "read orders"   on orders for select to anon using (true);
create policy "add orders"    on orders for insert to anon with check (true);
create policy "edit orders"   on orders for update to anon using (true);
create policy "remove orders" on orders for delete to anon using (true);

-- Live updates so everyone sees changes instantly
alter publication supabase_realtime add table orders;
