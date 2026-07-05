-- FacilityOS v4 Supabase Schema
-- Adds app user access with profiles.customer_id and profiles.employee_id.
-- Adds mobile menu in the app front-end.
-- Run this entire script in Supabase SQL Editor.

create extension if not exists "pgcrypto";

create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  logo_url text,
  brand_color text default '#ef3b1f',
  created_at timestamptz default now()
);

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  company_id uuid references companies(id) on delete set null,
  full_name text,
  role text not null default 'creator' check (role in ('creator','admin','manager','customer','employee','vendor')),
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
  monthly_value numeric default 0,
  created_at timestamptz default now()
);

create table if not exists facilities (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete cascade,
  name text not null,
  address text,
  access_notes text,
  service_notes text,
  status text default 'active',
  created_at timestamptz default now()
);

create table if not exists facility_areas (
  id uuid primary key default gen_random_uuid(),
  facility_id uuid references facilities(id) on delete cascade,
  name text not null,
  area_type text,
  instructions text,
  created_at timestamptz default now()
);

create table if not exists employees (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  profile_id uuid references profiles(id) on delete set null,
  full_name text not null,
  email text,
  phone text,
  role text default 'cleaner',
  status text default 'active',
  created_at timestamptz default now()
);

create table if not exists jobs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  facility_id uuid references facilities(id) on delete set null,
  area_id uuid references facility_areas(id) on delete set null,
  employee_id uuid references employees(id) on delete set null,
  title text not null,
  job_type text default 'recurring_cleaning',
  status text default 'scheduled',
  scheduled_at timestamptz,
  started_at timestamptz,
  completed_at timestamptz,
  notes text,
  created_at timestamptz default now()
);

create table if not exists checklist_items (
  id uuid primary key default gen_random_uuid(),
  job_id uuid references jobs(id) on delete cascade,
  label text not null,
  required boolean default true,
  requires_photo boolean default false,
  completed boolean default false,
  completed_at timestamptz,
  created_at timestamptz default now()
);

create table if not exists inspections (
  id uuid primary key default gen_random_uuid(),
  job_id uuid references jobs(id) on delete cascade,
  score numeric,
  manager_notes text,
  customer_visible boolean default false,
  created_at timestamptz default now()
);

create table if not exists maintenance_issues (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  facility_id uuid references facilities(id) on delete set null,
  area_id uuid references facility_areas(id) on delete set null,
  job_id uuid references jobs(id) on delete set null,
  title text not null,
  description text,
  status text default 'open',
  customer_visible boolean default false,
  created_at timestamptz default now()
);

create table if not exists quotes (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  issue_id uuid references maintenance_issues(id) on delete cascade,
  title text,
  amount numeric default 0,
  status text default 'draft',
  customer_response text,
  created_at timestamptz default now()
);

create table if not exists inventory_items (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  facility_id uuid references facilities(id) on delete set null,
  name text not null,
  category text,
  quantity numeric default 0,
  min_quantity numeric default 0,
  unit text default 'each',
  created_at timestamptz default now()
);

create table if not exists photos (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  job_id uuid references jobs(id) on delete set null,
  issue_id uuid references maintenance_issues(id) on delete set null,
  type text,
  file_path text,
  public_url text,
  created_at timestamptz default now()
);

-- v4 migrations for existing projects
alter table profiles add column if not exists customer_id uuid references customers(id) on delete set null;
alter table profiles add column if not exists employee_id uuid references employees(id) on delete set null;
alter table employees add column if not exists profile_id uuid references profiles(id) on delete set null;
alter table jobs add column if not exists area_id uuid references facility_areas(id) on delete set null;
alter table maintenance_issues add column if not exists area_id uuid references facility_areas(id) on delete set null;
alter table maintenance_issues add column if not exists customer_visible boolean default false;
alter table maintenance_issues add column if not exists job_id uuid references jobs(id) on delete set null;

alter table companies enable row level security;
alter table profiles enable row level security;
alter table customers enable row level security;
alter table facilities enable row level security;
alter table facility_areas enable row level security;
alter table employees enable row level security;
alter table jobs enable row level security;
alter table checklist_items enable row level security;
alter table inspections enable row level security;
alter table maintenance_issues enable row level security;
alter table quotes enable row level security;
alter table inventory_items enable row level security;
alter table photos enable row level security;

drop policy if exists "dev companies all" on companies;
create policy "dev companies all" on companies for all using (true) with check (true);

drop policy if exists "dev profiles all" on profiles;
create policy "dev profiles all" on profiles for all using (true) with check (true);

drop policy if exists "dev customers all" on customers;
create policy "dev customers all" on customers for all using (true) with check (true);

drop policy if exists "dev facilities all" on facilities;
create policy "dev facilities all" on facilities for all using (true) with check (true);

drop policy if exists "dev facility areas all" on facility_areas;
create policy "dev facility areas all" on facility_areas for all using (true) with check (true);

drop policy if exists "dev employees all" on employees;
create policy "dev employees all" on employees for all using (true) with check (true);

drop policy if exists "dev jobs all" on jobs;
create policy "dev jobs all" on jobs for all using (true) with check (true);

drop policy if exists "dev checklist all" on checklist_items;
create policy "dev checklist all" on checklist_items for all using (true) with check (true);

drop policy if exists "dev inspections all" on inspections;
create policy "dev inspections all" on inspections for all using (true) with check (true);

drop policy if exists "dev issues all" on maintenance_issues;
create policy "dev issues all" on maintenance_issues for all using (true) with check (true);

drop policy if exists "dev quotes all" on quotes;
create policy "dev quotes all" on quotes for all using (true) with check (true);

drop policy if exists "dev inventory all" on inventory_items;
create policy "dev inventory all" on inventory_items for all using (true) with check (true);

drop policy if exists "dev photos all" on photos;
create policy "dev photos all" on photos for all using (true) with check (true);
