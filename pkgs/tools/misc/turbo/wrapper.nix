{
  lib,
  symlinkJoin,
  makeWrapper,
  turbo-unwrapped,
  disableTelemetry ? true,
  disableUpdateNotifier ? true,
}:

symlinkJoin {
  pname = "turbo";
  name = "turbo-${turbo-unwrapped.version}";
  inherit (turbo-unwrapped) version meta;
  nativeBuildInputs = [ makeWrapper ];
  paths = [ turbo-unwrapped ];
  postBuild = ''
    rm $out/bin/turbo
    makeWrapper ${turbo-unwrapped}/bin/turbo $out/bin/turbo \
      ${lib.optionalString disableTelemetry "--set TURBO_TELEMETRY_DISABLED 1"} \
      ${lib.optionalString disableUpdateNotifier "--add-flags --no-update-notifier"}
  '';
}
