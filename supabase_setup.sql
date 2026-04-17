create extension if not exists pgcrypto;

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text,
  wins integer not null default 0 check (wins >= 0),
  build_name text not null default 'PROTO-01',
  robot_config jsonb not null default '{}'::jsonb,
  presets jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.player_wallet (
  user_id uuid primary key references auth.users(id) on delete cascade,
  coins integer not null default 0 check (coins >= 0),
  updated_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.player_inventory (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  item_type text not null check (item_type in ('piece', 'style')),
  piece_type text not null default '',
  item_key text not null,
  owned boolean not null default true,
  purchased_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists player_inventory_user_item_uidx
  on public.player_inventory (user_id, item_type, piece_type, item_key);

create table if not exists public.shop_items (
  id uuid primary key default gen_random_uuid(),
  item_type text not null check (item_type in ('piece', 'style')),
  piece_type text,
  item_key text not null,
  label text not null,
  description text not null default '',
  price integer not null check (price >= 0),
  rarity text not null default 'COMMUN',
  unlock_wins integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists shop_items_unique_uidx
  on public.shop_items (item_type, coalesce(piece_type, ''), item_key);

alter table public.profiles enable row level security;
alter table public.player_wallet enable row level security;
alter table public.player_inventory enable row level security;
alter table public.shop_items enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = user_id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
  on public.profiles for insert
  with check (auth.uid() = user_id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "wallet_select_own" on public.player_wallet;
create policy "wallet_select_own"
  on public.player_wallet for select
  using (auth.uid() = user_id);

drop policy if exists "wallet_insert_own" on public.player_wallet;
create policy "wallet_insert_own"
  on public.player_wallet for insert
  with check (auth.uid() = user_id);

drop policy if exists "wallet_update_own" on public.player_wallet;
create policy "wallet_update_own"
  on public.player_wallet for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "inventory_select_own" on public.player_inventory;
create policy "inventory_select_own"
  on public.player_inventory for select
  using (auth.uid() = user_id);

drop policy if exists "inventory_insert_own" on public.player_inventory;
create policy "inventory_insert_own"
  on public.player_inventory for insert
  with check (auth.uid() = user_id);

drop policy if exists "inventory_update_own" on public.player_inventory;
create policy "inventory_update_own"
  on public.player_inventory for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "shop_select_all" on public.shop_items;
create policy "shop_select_all"
  on public.shop_items for select
  using (true);

