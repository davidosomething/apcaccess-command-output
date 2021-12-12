#!/usr/bin/env bash

main() {
  command -v apcaccess >/dev/null || return 1
  local out
  out="$(apcaccess)"
  battery_percent=$(grep "BCHARGE" <<< "$out" | awk '{ print $3; }')
  if grep -q "STATUS   : ONLINE" <<< "$out"; then
    printf "UPS %s\n" "$battery_percent"
  else
    printf "UPS OFF\n"
  fi
}

main
