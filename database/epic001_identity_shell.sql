create extension if not exists "pgcrypto";
create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  legal_name text,
  logo_url text,
  brand_color text default '#ef3b1f',
  status text default 'active' check (status in ('active','paused','cancelled')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  company_id uuid references companies(id) on delete set null,
  full_name text,
  role text not null default 'owner' check (role in ('owner','admin','manager','supervisor','employee','customer','vendor','sales_rep','account_manager')),
  customer_id uuid,
  employee_id uuid,
  vendor_id uuid,
  avatar_url text,
  status text default 'active',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create table if not exists app_notifications (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  profile_id uuid references profiles(id) on delete cascade,
  title text not null,
  body text,
  priority text default 'info',
  read_at timestamptz,
  created_at timestamptz default now()
);
create table if not exists activity_events (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  actor_profile_id uuid references profiles(id) on delete set null,
  entity_type text not null,
  entity_id uuid,
  action text not null,
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);
create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  name text not null,
  contact_name text,
  email text,
  phone text,
  status text default 'active',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create table if not exists facilities (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete cascade,
  name text not null,
  address text,
  status text default 'active',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table profiles add constraint profiles_customer_id_fkey foreign key (customer_id) references customers(id) on delete set null;
alter table companies enable row level security;
alter table profiles enable row level security;
alter table app_notifications enable row level security;
alter table activity_events enable row level security;
alter table customers enable row level security;
alter table facilities enable row level security;
drop policy if exists "dev companies all" on companies;
create policy "dev companies all" on companies for all using (true) with check (true);
drop policy if exists "dev profiles all" on profiles;
create policy "dev profiles all" on profiles for all using (true) with check (true);
drop policy if exists "dev notifications all" on app_notifications;
create policy "dev notifications all" on app_notifications for all using (true) with check (true);
drop policy if exists "dev activity all" on activity_events;
create policy "dev activity all" on activity_events for all using (true) with check (true);
drop policy if exists "dev customers all" on customers;
create policy "dev customers all" on customers for all using (true) with check (true);
drop policy if exists "dev facilities all" on facilities;
create policy "dev facilities all" on facilities for all using (true) with check (true);
