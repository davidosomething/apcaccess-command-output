#!/usr/bin/env bash

main() {
	command -v upsc >/dev/null || return 1
	local out
	out="$(upsc "$1")"

	local pct
	pct=$(grep "battery.charge:" <<<"$out" | awk '{ print $2; }')

	local threshhold=90
	local icon
	if (($(echo "${pct} > ${threshhold}" | bc -l))); then
		icon="🔋"
	else
		icon="🪫"
	fi

	if grep -q "ups.status: OL" <<<"$out"; then
		printf "UPS%s%s\n" "$icon" "$pct"
	else
		printf "UPS OFF\n"
	fi
}

main "$1"
