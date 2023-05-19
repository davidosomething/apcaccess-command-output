#!/usr/bin/env bash

main() {
  command -v upsc >/dev/null || return 1
  local out
  out="$(upsc "$1")"
  battery_percent=$(grep "battery.charge:" <<< "$out" | awk '{ print $2; }')
  if grep -q "ups.status: OL" <<< "$out"; then
    printf "UPS %s\n" "$battery_percent"
  else
    printf "UPS OFF\n"
  fi
}

main "$1"
