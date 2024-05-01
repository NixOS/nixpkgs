{ lib, runCommand, makeWrapper, turbo-unwrapped
, disableTelemetry ? true, disableUpdateNotifier ? true }:

runCommand "turbo" { nativeBuildInputs = [ makeWrapper ]; } ''
  mkdir -p $out/bin
  makeWrapper ${turbo-unwrapped}/bin/turbo $out/bin/turbo \
    ${lib.optionalString disableTelemetry "--set TURBO_TELEMETRY_DISABLED 1"} \
    ${lib.optionalString disableUpdateNotifier "--add-flags --no-update-notifier"}
''
