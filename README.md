# FacilityOS Core — Epic 001

Identity & Application Shell foundation.

## Includes
- React/Vite architecture
- Supabase client
- Logo-triggered login/account modal
- Professional account panel
- Role-aware portals
- Desktop sidebar
- Mobile drawer
- Mobile bottom navigation
- Mission Control dashboard
- Company setup module
- GitHub Pages deployment workflow
- Epic 001 SQL schema

## Codespaces setup

```bash
npm install
cp .env.example .env
npm run dev
```

## Supabase

Run:

```text
database/epic001_identity_shell.sql
```

## GitHub Pages

Add repository secrets:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

Then set Pages source to GitHub Actions.

## Principle

Connect → Plan → Execute → Verify → Improve

If it is not verified, it is not complete.
