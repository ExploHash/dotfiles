#!/bin/bash

used_mem=$(free | awk '/Mem:/ { printf("%d", ($2 - $7) / $2 * 100) }')
used_swap=$(free | awk '/Swap:/ { if ($2 > 0) printf("%d", $3 / $2 * 100); else print 0 }')

echo "{\"text\": \"${used_mem}%\", \"tooltip\": \"Swap used: ${used_swap}%\"}"

