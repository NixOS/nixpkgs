#!/usr/bin/env bash
set -eEuo pipefail
test -z "${DEBUG:-}" || set -x

usage() {
  cat <<'EOF'
Example usage:
  linuxhw-get-edid-bin PG278Q 2014 >edid.bin
  edid-decode <edid.bin
  parse-edid <edid.bin
  cat edid.bin >/sys/kernel/debug/dri/0/DP-1/edid_override
EOF
}

print() {
  # shellcheck disable=SC2059
  printf "${1}\n" "${@:2}"
}

log() {
  print "${@}" >&2
}

find_displays() {
  local script=(
    "BEGIN { IGNORECASE=1 }"
    "/${1}/"
  )

  for pattern in "${@:2}"; do
    script+=('&&' "/${pattern}/")
  done
  cat {Analog,Digital}Display.md | awk "${script[*]}"
}

to_edid() {
  if ! test -e "$1"; then
    log "$1 does not exist"
    return 1
  fi

  # https://github.com/linuxhw/EDID/blob/228fea5d89782402dd7f84a459df7f5248573b10/README.md#L42-L42
  grep -E '^([a-f0-9]{32}|[a-f0-9 ]{47})$' <"$1" | tr -d '[:space:]' | xxd -r -p
}

extract_path() {
  awk '{ gsub(/^.+]\(</, ""); gsub(/>).+/, ""); print }'
}

main() {
  test $# -gt 0 || usage

  log "running in $PWD"

  readarray -t lines < <(find_displays "${@}")
  case "${#lines[@]}" in
  0)
    log "No matches, try broader patterns?"
    exit 1
    ;;
  1)
    log "%s" "${lines[@]}"
    log "Found exactly one pattern, continuing..."
    ;;
  *)
    log "Matched entries:"
    log "%s" "${lines[@]}"
    log ""
    log "More than one match, try more specific patterns?"
    exit 2
    ;;
  esac

  to_edid "$(extract_path <<<"${lines[0]}")"
}

main "$@"
