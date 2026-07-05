-- FacilityOS 1.0 Foundation Supabase Schema
-- Clean multi-tenant foundation.
-- Run in a new Supabase project, or reset old prototype tables first if needed.

create extension if not exists "pgcrypto";

-- =========================================================
-- CORE TENANCY / USERS
-- =========================================================

create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  legal_name text,
  logo_url text,
  brand_color text default '#ef3b1f',
  status text default 'active',
  created_at timestamptz default now()
);

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  company_id uuid references companies(id) on delete set null,
  full_name text,
  role text not null default 'owner'
    check (role in ('owner','admin','manager','supervisor','employee','customer','vendor','sales_rep','account_manager')),
  customer_id uuid,
  employee_id uuid,
  vendor_id uuid,
  status text default 'active',
  created_at timestamptz default now()
);

-- =========================================================
-- CRM / CUSTOMERS / FACILITIES
-- =========================================================

create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  name text not null,
  contact_name text,
  email text,
  phone text,
  status text default 'active' check (status in ('lead','active','paused','cancelled')),
  account_manager_id uuid references profiles(id) on delete set null,
  sales_rep_id uuid references profiles(id) on delete set null,
  created_at timestamptz default now()
);

alter table profiles
  add constraint profiles_customer_id_fkey foreign key (customer_id) references customers(id) on delete set null;

create table if not exists facilities (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete cascade,
  name text not null,
  address text,
  access_notes text,
  service_notes text,
  status text default 'active' check (status in ('onboarding','active','paused','cancelled')),
  created_at timestamptz default now()
);

create table if not exists facility_areas (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  facility_id uuid references facilities(id) on delete cascade,
  name text not null,
  area_type text,
  instructions text,
  qr_code_value text unique,
  created_at timestamptz default now()
);

-- =========================================================
-- EMPLOYEES / VENDORS
-- =========================================================

create table if not exists employees (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  profile_id uuid references profiles(id) on delete set null,
  full_name text not null,
  email text,
  phone text,
  role text default 'cleaner',
  hourly_rate numeric default 0,
  status text default 'active' check (status in ('active','inactive','suspended')),
  created_at timestamptz default now()
);

alter table profiles
  add constraint profiles_employee_id_fkey foreign key (employee_id) references employees(id) on delete set null;

create table if not exists vendors (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  name text not null,
  vendor_type text,
  email text,
  phone text,
  status text default 'pending' check (status in ('pending','approved','inactive')),
  created_at timestamptz default now()
);

alter table profiles
  add constraint profiles_vendor_id_fkey foreign key (vendor_id) references vendors(id) on delete set null;

-- =========================================================
-- SERVICES / SOPs
-- =========================================================

create table if not exists services (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  name text not null,
  category text,
  description text,
  base_price numeric default 0,
  status text default 'active' check (status in ('active','inactive')),
  created_at timestamptz default now()
);

create table if not exists service_tiers (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  name text not null,
  description text,
  monthly_price numeric default 0,
  enabled_modules jsonb default '[]'::jsonb,
  created_at timestamptz default now()
);

create table if not exists sops (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  service_id uuid references services(id) on delete set null,
  title text not null,
  category text,
  body text,
  status text default 'active' check (status in ('draft','active','archived')),
  created_at timestamptz default now()
);

-- =========================================================
-- JOBS / CHECKLISTS / INSPECTIONS
-- =========================================================

create table if not exists jobs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  facility_id uuid references facilities(id) on delete set null,
  area_id uuid references facility_areas(id) on delete set null,
  employee_id uuid references employees(id) on delete set null,
  service_id uuid references services(id) on delete set null,
  title text not null,
  job_type text default 'recurring_cleaning',
  status text default 'scheduled'
    check (status in ('scheduled','in_progress','completed','reviewed','billed','cancelled')),
  scheduled_at timestamptz,
  started_at timestamptz,
  completed_at timestamptz,
  notes text,
  created_at timestamptz default now()
);

create table if not exists checklist_items (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  job_id uuid references jobs(id) on delete cascade,
  sop_id uuid references sops(id) on delete set null,
  label text not null,
  required boolean default true,
  requires_photo boolean default false,
  completed boolean default false,
  completed_at timestamptz,
  created_at timestamptz default now()
);

create table if not exists inspections (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  job_id uuid references jobs(id) on delete cascade,
  score numeric,
  manager_notes text,
  customer_visible boolean default false,
  created_at timestamptz default now()
);

-- =========================================================
-- ISSUES / QUOTES / INVOICES / PHOTOS
-- =========================================================

create table if not exists maintenance_issues (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  facility_id uuid references facilities(id) on delete set null,
  area_id uuid references facility_areas(id) on delete set null,
  job_id uuid references jobs(id) on delete set null,
  title text not null,
  description text,
  status text default 'open'
    check (status in ('open','reviewed','quoted','approved','scheduled','completed','closed')),
  priority text default 'normal' check (priority in ('low','normal','high','urgent')),
  customer_visible boolean default false,
  created_at timestamptz default now()
);

create table if not exists quotes (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  issue_id uuid references maintenance_issues(id) on delete set null,
  title text not null,
  amount numeric default 0,
  status text default 'draft' check (status in ('draft','sent','approved','rejected','expired')),
  customer_response text,
  created_at timestamptz default now()
);

create table if not exists invoices (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  quote_id uuid references quotes(id) on delete set null,
  invoice_number text not null,
  total numeric default 0,
  status text default 'draft' check (status in ('draft','sent','paid','overdue','void')),
  due_date date,
  created_at timestamptz default now()
);

create table if not exists photos (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  job_id uuid references jobs(id) on delete set null,
  issue_id uuid references maintenance_issues(id) on delete set null,
  type text default 'before',
  file_path text,
  public_url text,
  created_at timestamptz default now()
);

-- =========================================================
-- FUTURE-READY SUPPORT TABLES
-- =========================================================

create table if not exists expenses (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  vendor_id uuid references vendors(id) on delete set null,
  customer_id uuid references customers(id) on delete set null,
  job_id uuid references jobs(id) on delete set null,
  category text,
  description text,
  amount numeric default 0,
  expense_date date default current_date,
  created_at timestamptz default now()
);

create table if not exists documents (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  customer_id uuid references customers(id) on delete set null,
  facility_id uuid references facilities(id) on delete set null,
  title text not null,
  document_type text,
  file_path text,
  status text default 'draft',
  created_at timestamptz default now()
);

create table if not exists automation_rules (
  id uuid primary key default gen_random_uuid(),
  company_id uuid references companies(id) on delete cascade,
  name text not null,
  trigger_event text not null,
  conditions jsonb default '{}'::jsonb,
  actions jsonb default '[]'::jsonb,
  active boolean default true,
  created_at timestamptz default now()
);

-- =========================================================
-- INDEXES
-- =========================================================

create index if not exists idx_customers_company on customers(company_id);
create index if not exists idx_facilities_company_customer on facilities(company_id, customer_id);
create index if not exists idx_areas_facility on facility_areas(facility_id);
create index if not exists idx_jobs_company_status on jobs(company_id, status);
create index if not exists idx_jobs_employee on jobs(employee_id);
create index if not exists idx_issues_facility_area on maintenance_issues(facility_id, area_id);
create index if not exists idx_quotes_customer_status on quotes(customer_id, status);
create index if not exists idx_invoices_customer_status on invoices(customer_id, status);

-- =========================================================
-- DEV RLS POLICIES
-- Production RLS should be tightened by company_id + profile role.
-- =========================================================

alter table companies enable row level security;
alter table profiles enable row level security;
alter table customers enable row level security;
alter table facilities enable row level security;
alter table facility_areas enable row level security;
alter table employees enable row level security;
alter table vendors enable row level security;
alter table services enable row level security;
alter table service_tiers enable row level security;
alter table sops enable row level security;
alter table jobs enable row level security;
alter table checklist_items enable row level security;
alter table inspections enable row level security;
alter table maintenance_issues enable row level security;
alter table quotes enable row level security;
alter table invoices enable row level security;
alter table photos enable row level security;
alter table expenses enable row level security;
alter table documents enable row level security;
alter table automation_rules enable row level security;

drop policy if exists "dev companies all" on companies;
create policy "dev companies all" on companies for all using (true) with check (true);

drop policy if exists "dev profiles all" on profiles;
create policy "dev profiles all" on profiles for all using (true) with check (true);

drop policy if exists "dev customers all" on customers;
create policy "dev customers all" on customers for all using (true) with check (true);

drop policy if exists "dev facilities all" on facilities;
create policy "dev facilities all" on facilities for all using (true) with check (true);

drop policy if exists "dev areas all" on facility_areas;
create policy "dev areas all" on facility_areas for all using (true) with check (true);

drop policy if exists "dev employees all" on employees;
create policy "dev employees all" on employees for all using (true) with check (true);

drop policy if exists "dev vendors all" on vendors;
create policy "dev vendors all" on vendors for all using (true) with check (true);

drop policy if exists "dev services all" on services;
create policy "dev services all" on services for all using (true) with check (true);

drop policy if exists "dev tiers all" on service_tiers;
create policy "dev tiers all" on service_tiers for all using (true) with check (true);

drop policy if exists "dev sops all" on sops;
create policy "dev sops all" on sops for all using (true) with check (true);

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

drop policy if exists "dev invoices all" on invoices;
create policy "dev invoices all" on invoices for all using (true) with check (true);

drop policy if exists "dev photos all" on photos;
create policy "dev photos all" on photos for all using (true) with check (true);

drop policy if exists "dev expenses all" on expenses;
create policy "dev expenses all" on expenses for all using (true) with check (true);

drop policy if exists "dev documents all" on documents;
create policy "dev documents all" on documents for all using (true) with check (true);

drop policy if exists "dev automations all" on automation_rules;
create policy "dev automations all" on automation_rules for all using (true) with check (true);
