# FacilityOS AI - Role Based Supabase v2

## Role organization

### Creator / Admin
Full business control:
- Dashboard
- Customers
- Facilities
- Jobs and schedule
- Employees
- Inspections
- Maintenance opportunities
- Quotes
- Inventory
- Reports
- Settings

### Customer
Customer sees proof and value:
- Service visits
- Completed jobs
- Photos and reports
- Issues needing approval
- Quotes
- Billing

Customer should not see margins, employee performance, payroll, internal notes, or admin settings.

### Employee
Employee sees execution only:
- Today's assigned jobs
- Cleaning checklist
- Photo upload
- Report issue
- Time clock

Employee should not see pricing, customer contracts, revenue, or private business data.

## Supabase
Project URL is already configured:

https://sjjeqxjsspcaxommavac.supabase.co

Run `supabase-schema.sql` in Supabase SQL Editor first.

## GitHub Pages
Upload these files to your repo root:
- index.html
- manifest.json
- supabase-schema.sql
- README.md

Then: Settings -> Pages -> Deploy from branch -> main -> root.

## Brand color
Accent color changed to a redder orange closer to your logo:

#ef3b1f
