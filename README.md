# FacilityOS Static Complete v1

A premium static prototype for a cleaning + facility management operating system.

## What is included

- `index.html` — complete static app prototype
- `manifest.json` — PWA metadata
- `supabase-schema.sql` — starter Supabase database schema

## Deploy to GitHub Pages

1. Create a GitHub repository.
2. Upload these files to the repository root.
3. Go to **Settings → Pages**.
4. Choose **Deploy from branch**.
5. Select branch: `main` and folder: `/root`.
6. Save and open the GitHub Pages URL.

## Supabase setup

1. Create a Supabase project.
2. Open **SQL Editor**.
3. Paste and run `supabase-schema.sql`.
4. Go to **Project Settings → API**.
5. Copy your Project URL and anon public key.
6. Open the app → Settings → paste values.

This v1 saves config locally only. The next version can connect the screens to Supabase CRUD actions.

## Suggested next build order

1. Supabase Auth login
2. Real customers CRUD
3. Real facilities CRUD
4. Real jobs and checklist completion
5. Supabase Storage photo upload
6. Customer portal approval links
7. Employee mobile view
8. Maintenance quote approval workflow
