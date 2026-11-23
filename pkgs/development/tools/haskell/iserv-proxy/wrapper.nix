{
  stdenv,
  haskell,
  buildHaskellPackages,
  buildPackages,
  iserv-proxy,
  writeShellSriptBin,
}:

let
  emulator = stdenv.hostPlatform.emulator buildPackages;

  makeWrapperScript =
    enableProfiling:
    let
      iserv-proxy = haskell.lib.compose.overrideCabal {
        enableLibraryProfiling = enableProfiling;
        enableExecutableProfiling = enableProfiling;
      } iserv-proxy;
    in
    writeShellScriptBin ("iserv-wrapper" + lib.optionalString enableProfiling "-prof") ''
      set -euo pipefail
      PORT=$((5000 + $RANDOM % 5000))
      (>&2 echo "---> Starting interpreter on port $PORT")
      ${emulator} ${lib.getExe' iserv-proxy "iserv-proxy"} tmp $PORT &
      RISERV_PID="$!"
      trap "kill $RISERV_PID" EXIT # Needs cleanup when building without sandbox
      ${lib.getExe' buildHaskellPackages.iserv-proxy "iserv-proxy"} $@ 127.0.0.1 "$PORT"
      (>&2 echo "---> killing interpreter...")
    '';
in

symlinkJoin {
  name = "iserv-proxy-wrapper";
  paths = map makeWrapperScript [
    false
    true
  ];
}
