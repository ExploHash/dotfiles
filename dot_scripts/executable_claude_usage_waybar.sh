#!/usr/bin/env bash
# Claude usage for waybar: <session%>/<weekly%>
# Session = 5-hour rolling limit, weekly = 7-day limit.

CREDS="$HOME/.claude/.credentials.json"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/claude_usage_waybar.json"

fail() {
  # Serve the last good reading (up to 2h old) instead of blanking the display
  if [ -f "$CACHE" ] && [ -n "$(find "$CACHE" -mmin -120 2>/dev/null)" ]; then
    cat "$CACHE"
  else
    echo '{"text": "? / ?", "tooltip": "Claude usage unavailable", "class": "error"}'
  fi
  exit 0
}

[ -r "$CREDS" ] || fail

TOKEN=$(jq -r '.claudeAiOauth.accessToken // empty' "$CREDS")
[ -n "$TOKEN" ] || fail

RESP=$(curl -sf --max-time 10 https://api.anthropic.com/api/oauth/usage \
  -H "Authorization: Bearer $TOKEN" \
  -H "anthropic-beta: oauth-2025-04-20") || fail

echo "$RESP" | jq -c --arg now "$(date -u +%s)" '
  def pct(x): if x == null then "?" else (x | round | tostring) end;
  def until(t):
    if t == null then "n/a"
    else (((t | sub("\\.[0-9]+"; "") | sub("\\+00:00$"; "Z") | fromdateiso8601) - ($now | tonumber)) as $s
      | if $s <= 0 then "now"
        elif $s >= 86400 then "\($s / 86400 | floor)d \(($s % 86400) / 3600 | floor)h"
        else "\($s / 3600 | floor)h \(($s % 3600) / 60 | floor)m" end)
    end;
  (.five_hour.utilization // null) as $s
  | (.seven_day.utilization // null) as $w
  | ([$s // 0, $w // 0] | max) as $max
  | {
      text: "\(pct($s))% / \(pct($w))%",
      tooltip: "Claude usage\nSession (5h): \(pct($s))% — resets in \(until(.five_hour.resets_at))\nWeekly: \(pct($w))% — resets in \(until(.seven_day.resets_at))",
      class: (if $max >= 90 then "critical" elif $max >= 70 then "warning" else "normal" end)
    }' 2>/dev/null > "${CACHE}.tmp" || { rm -f "${CACHE}.tmp"; fail; }
mv "${CACHE}.tmp" "$CACHE"
cat "$CACHE"
