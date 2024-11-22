#!/usr/bin/env bash

# param 1 "host:port"
main() {
	command -v apcaccess >/dev/null || return 1
	local out
	out="$(apcaccess -h "${1:-"localhost:3551"}")"

	# ===========================================================================
	# Battery charge
	# ===========================================================================

	local charge_threshold=90
	local charge
	charge=$(grep "BCHARGE" <<<"$out" | awk '{ print $3; }')
	local icon
	if (($(echo "${charge} > ${charge_threshold}" | bc -l))); then
		icon="🔋"
	else
		icon="🪫"
	fi
	if grep -q "STATUS   : ONLINE" <<<"$out"; then
		printf "UPS%s%s" "$icon" "$charge"
	else
		printf "UPS OFF"
	fi

	# ===========================================================================
	# Power consumption
	# ===========================================================================

	local loadpct
	loadpct=$(grep "LOADPCT" <<<"$out" | awk '{ print $3; }')
	local nompower
	nompower=$(grep "NOMPOWER" <<<"$out" | awk '{ print $3; }')
	local loadw
	loadw=$(bc -l <<<"${nompower} * (${loadpct} / 100)")
	# display only whole number
	printf " | %s W\n" "${loadw%.*}"
}

main "$@"
