#!/usr/bin/env bash

# param 1 "host:port"
main() {
	command -v apcaccess >/dev/null || return 1
	local out
	out="$(apcaccess -h ${1:-"localhost:3551"})"

	local pct
	pct=$(grep "BCHARGE" <<<"$out" | awk '{ print $3; }')

	local threshhold=90
	local icon
	if (($(echo "${pct} > ${threshhold}" | bc -l))); then
		icon="🔋"
	else
		icon="🪫"
	fi

	if grep -q "STATUS   : ONLINE" <<<"$out"; then
		printf "UPS%s%s\n" "$icon" "$pct"
	else
		printf "UPS OFF\n"
	fi
}

main "$@"
