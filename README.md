# FacilityOS AI v4 - Users + Mobile Menu

## What changed

1. Added a real mobile sidebar menu.
   - On phone, tap `☰ Menu`.
   - Sidebar opens as a drawer.
   - Tap outside to close.

2. Added Users & Access.
   - Supabase login users are in Authentication → Users.
   - App roles are stored in `profiles`.
   - `profiles.customer_id` links a customer portal user.
   - `profiles.employee_id` links an employee app user.

## Correct access structure

auth.users = login account  
profiles = role and access  
customers = customer accounts  
employees = worker records  

## Role logic

Creator/Admin:
- sees everything

Customer:
- should only see records linked to their `customer_id`

Employee:
- should only see jobs linked to their `employee_id`

This version has development policies so you can build fast. Production RLS comes later.

## Steps

1. Replace repo files.
2. Run `supabase-schema.sql` in Supabase SQL Editor.
3. Refresh GitHub Pages.
4. Login.
5. Go to Creator/Admin → Users & Access.
6. Click Create/Update My Creator Profile.
7. Assign customer/employee access as needed.

Supabase URL already configured:

https://sjjeqxjsspcaxommavac.supabase.co
