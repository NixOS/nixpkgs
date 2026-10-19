#!/usr/bin/env bash
set -euo pipefail

if [[ ${1-} == child ]]; then
  shift
  mode=$1 setup=$2 hook=$3 root=$4
  fixture=$5 temp=$6 state=$7 call_log=$8 expected_status=$9
  . "$setup"
  . "$hook"
  export TMPDIR="$temp" NIX_BUILD_CORES=1

  finish_child() {
    local status=$?
    printf 'child_exit=%s remaining_jobs=%s caller_locale=%s\n' "$status" "$(jobs -pr)" "${LC_ALL-}" > "$state" || status=$?
    (exit "$status")
    exitHandler
  }
  trap finish_child EXIT

  if [[ $mode == classifier ]]; then
    audit_test_parent=$BASHPID
    printf '%s\n' "$audit_test_parent" > "$call_log.parent"
    isELF() {
      [[ $BASHPID == "$audit_test_parent" ]] && return 1
      printf '%s\n' "$LC_ALL" > "$call_log.locale"
      printf '%s\n' "$BASHPID" >> "$call_log"
      exit 73
    }
  elif [[ $mode == find ]]; then
    find() { return 41; }
  fi

  case $mode in
    classifier)
      export LC_ALL=POSIX
      if [[ $expected_status == direct ]]; then
        set -e
        auditTmpdir "$fixture"
      else
        if auditTmpdir "$fixture"; then status=0; else status=$?; fi
        printf 'returned=%s\n' "$status"
        exit "$status"
      fi
      ;;
    find)
      if auditTmpdir "$fixture"; then status=0; else status=$?; fi
      printf 'returned=%s\n' "$status"
      exit "$status"
      ;;
    safe-wrapper)
      auditTmpdir "$fixture"
      [[ -z $(jobs -pr) ]]
      ;;
    unsafe-wrapper)
      if auditTmpdir "$fixture"; then status=0; else status=$?; fi
      printf 'returned=%s\n' "$status"
      exit "$status"
      ;;
    *)
      echo "unknown child mode: $mode" >&2
      exit 2
      ;;
  esac
  exit 0
fi

setup=$1
hook=$2
bash_bin=$3
. "$setup"
root="$NIX_BUILD_TOP/audit-tmpdir-test.$$"
logs="$root/logs"
temp="$root/tmp"
ordinary="$root/ordinary"
unsafe="$root/unsafe"
mkdir -m 700 -p "$logs" "$temp" "$ordinary" "$unsafe"

fail() { echo "FAIL: $*" >&2; exit 1; }
check_no_jobs_and_fifo_cleanup() {
  local state=$1 label=$2 exit_file=$3 child_status
  child_status=$(cat "$exit_file")
  grep -Eq "^child_exit=$child_status remaining_jobs= caller_locale=" "$state" || fail "$label left child jobs running"
  [[ -z $(find "$temp" -mindepth 1 -maxdepth 1 -print) ]] || fail "$label left FIFO scratch behind"
}
run_child() {
  local mode=$1 caller=$2 fixture=$3 expected=$4 stem=$5
  local status
  set +e
  "$bash_bin" "$0" child "$mode" "$setup" "$hook" "$root" "$fixture" "$temp" "$logs/$stem.state" "$logs/$stem.calls" "$caller" > "$logs/$stem.log" 2>&1
  status=$?
  set -e
  if [[ $expected == nonzero ]]; then
    [[ $status -ne 0 && $status -ne 124 && $status -ne 137 ]] || fail "$stem returned $status, expected a non-timeout failure"
  else
    [[ $status -eq $expected ]] || fail "$stem returned $status, expected $expected"
  fi
  printf '%s\n' "$status" > "$logs/$stem.exit"
}

printf 'plain fixture\n' > "$ordinary/plain"

# Both caller contexts must receive the fatal classifier subprocess status.
for caller in direct conditional; do
  stem="classifier-$caller"
  run_child classifier "$caller" "$ordinary" 73 "$stem"
  grep -Fq 'classifier/find pipeline failed with status 73' "$logs/$stem.log" || fail "$stem diagnostic missing"
  check_no_jobs_and_fifo_cleanup "$logs/$stem.state" "$stem" "$logs/$stem.exit"
  grep -Fxq 'C' "$logs/$stem.calls.locale" || fail "$stem classifier did not observe LC_ALL=C"
  grep -Fxq "child_exit=73 remaining_jobs= caller_locale=POSIX" "$logs/$stem.state" || fail "$stem changed its caller locale"
  [[ $(wc -l < "$logs/$stem.calls") -eq 1 ]] || fail "$stem did not invoke the classifier exactly once"
  classifier_pid=$(cat "$logs/$stem.calls")
  [[ $classifier_pid != "$(cat "$logs/$stem.calls.parent")" ]] || fail "$stem override ran in the caller"
  if kill -0 "$classifier_pid" 2>/dev/null; then fail "$stem classifier process remains alive"; fi
  if [[ $caller == conditional ]]; then grep -Fxq 'returned=73' "$logs/$stem.log" || fail "$stem conditional status mismatch"; fi
done

# A failing find must survive both pipefail and the final FIFO descriptor close.
run_child find conditional "$ordinary" 41 find-failure
grep -Fq 'classifier/find pipeline failed with status 41' "$logs/find-failure.log" || fail "find failure diagnostic missing"
grep -Fxq 'returned=41' "$logs/find-failure.log" || fail "find failure status mismatch"
check_no_jobs_and_fifo_cleanup "$logs/find-failure.state" find-failure "$logs/find-failure.exit"

# Existing wrapper behavior remains: safe scripts pass and TMPDIR references fail.
printf '#!/bin/sh\nexit 0\n' > "$ordinary/tool"
: > "$ordinary/.tool-wrapped"
chmod +x "$ordinary/tool"
unicode_tool="$ordinary/tool-é"
printf '#!/bin/sh\nexit 0\n' > "$unicode_tool"
: > "$ordinary/.tool-é-wrapped"
chmod +x "$unicode_tool"
run_child safe-wrapper unused "$ordinary" 0 safe-wrapper
check_no_jobs_and_fifo_cleanup "$logs/safe-wrapper.state" safe-wrapper "$logs/safe-wrapper.exit"

unicode_unsafe_tool="$unsafe/tool-é"
printf '#!/bin/sh\nexec cat %s/temporary-file\n' "$temp" > "$unicode_unsafe_tool"
: > "$unsafe/.tool-é-wrapped"
chmod +x "$unicode_unsafe_tool"
run_child unsafe-wrapper unused "$unsafe" nonzero unsafe-wrapper
grep -Fq 'contains a forbidden reference to ' "$logs/unsafe-wrapper.log" || fail "unsafe wrapper rejection diagnostic missing"
check_no_jobs_and_fifo_cleanup "$logs/unsafe-wrapper.state" unsafe-wrapper "$logs/unsafe-wrapper.exit"

rm -rf "$root"
mkdir -p "$out"

echo 'PASS: fatal classifier exit propagated to direct and conditional callers; classifier and FIFO handlers reaped'
echo 'PASS: find failure propagated through the final FIFO close'
echo 'PASS: safe wrapper accepted and TMPDIR-bearing wrapper rejected'
