-- Apokolips Messenger profile foundation.
-- Namespaced objects only; this does not modify unrelated app tables.

create table if not exists public.apm_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  public_id text not null unique default (
    'APM-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 10))
  ),
  display_name text not null check (char_length(trim(display_name)) between 2 and 60),
  username text not null check (username ~ '^[a-zA-Z0-9_]{3,24}$'),
  created_at timestamptz not null default now()
);

create unique index if not exists apm_profiles_username_lower_uidx
  on public.apm_profiles (lower(username));

alter table public.apm_profiles enable row level security;

drop policy if exists "apm_profiles_select_own" on public.apm_profiles;
create policy "apm_profiles_select_own"
  on public.apm_profiles for select to authenticated
  using ((select auth.uid()) = id);

drop policy if exists "apm_profiles_insert_own" on public.apm_profiles;
create policy "apm_profiles_insert_own"
  on public.apm_profiles for insert to authenticated
  with check ((select auth.uid()) = id);

grant select, insert on public.apm_profiles to authenticated;
revoke all on public.apm_profiles from anon;

comment on table public.apm_profiles is
  'Apokolips Messenger user profiles; isolated with the apm_ prefix.';
