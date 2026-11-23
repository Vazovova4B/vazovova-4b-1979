// Cloudflare Pages Functions - functions/api/config.js
// Tento subor NEOBSAHUJE ziadne kluce.
// Kluce cita z Cloudflare Environment variables (Pages -> Settings -> Environment variables).
// Uloz ho v GitHub repozitari ako: functions/api/config.js
export async function onRequest(context) {
  const url = context.env.SUPABASE_URL || "";
  const anonKey = context.env.SUPABASE_ANON_KEY || "";
  return new Response(JSON.stringify({ url, anonKey }), {
    headers: {
      "Content-Type": "application/json",
      "Cache-Control": "no-store",
    },
  });
}
