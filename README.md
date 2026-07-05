# FacilityOS 1.0 Foundation

Technical build package for the clean FacilityOS foundation.

## Stack

- React
- Vite
- Supabase Auth
- Supabase PostgreSQL
- Supabase-ready multi-tenant schema
- Role-aware portals
- Mobile drawer
- Mobile bottom navigation

## Included connected modules

- Company Setup
- Profiles / Users
- Customers
- Facilities
- Areas
- Employees
- Services
- Jobs
- Checklists
- SOPs / Manuals
- Issues
- Quotes
- Invoices
- Photos

## Project setup

```bash
npm install
cp .env.example .env
npm run dev
```

## Supabase setup

1. Open Supabase.
2. Go to SQL Editor.
3. Run `supabase-schema.sql`.
4. In the project settings, confirm the URL and anon key match `.env`.

Supabase URL already included in `.env.example`:

```txt
https://sjjeqxjsspcaxommavac.supabase.co
```

## Recommended build workflow

From this point forward, add features by module and workflow only.

Examples:

- Module: Inventory
- Workflow: Low supply report → manager approval → purchase order
- Module: Payroll
- Workflow: Clock in/out → approved hours → payroll summary
- Module: QR Codes
- Workflow: Scan area QR → load SOP/checklist → verify job location
- Module: Photos
- Workflow: Upload before/after photos → Supabase Storage → customer report
- Module: Automations
- Workflow: Job completed → generate report → notify customer → draft invoice

Avoid patching isolated screens.
