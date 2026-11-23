# Gymnázium Vazovova 4.B 1979

Živá stránka: https://vazovova-4b-1979.pages.dev

## Čo je v balíčku
- `index.html` - kompletná stránka, BEZ kľúčov. Prihlásenie / registrácia / zabudnuté heslo cez Supabase Auth.
- `functions/api/config.js` - Cloudflare Pages Function. Číta SUPABASE_URL a SUPABASE_ANON_KEY z Cloudflare Environment variables. V súbore NIE SÚ žiadne kľúče.
- `supabase.sql` - databáza: 37 spolužiakov, stav `už nežije` pre Ivaško / Topoľský / Danielová, RLS pre čítanie aj zápis prihlásených.
- `trieda.png` - triedna fotka na pozadie.

## Kľúče - NIKDY nie do GitHubu
Kľúče sú LEN v Cloudflare -> Pages -> vazovova-4b-1979 -> Settings -> Environment variables:
- SUPABASE_URL
- SUPABASE_ANON_KEY (Publishable, sb_publishable_...)
Nikdy sem nedávaj Secret kľúč (sb_secret_...).

## Nahratie na GitHub
1. V GitHub repozitári Vazovova4B/vazovova-4b-1979 vymaž staré súbory (alebo ich prepíš).
2. Nahraj CELÝ obsah tohto ZIPu - aj priečinok `functions/`.
3. Cloudflare Pages sa sám nasadí. Over na vazovova-4b-1979.pages.dev.

## Supabase - jednorazovo
1. Supabase -> projekt vazovova4b -> SQL Editor -> New query -> vlož `supabase.sql` -> Run.
2. Supabase -> Authentication -> v prípade potreby zapni Email provider a potvrdenie emailu.
