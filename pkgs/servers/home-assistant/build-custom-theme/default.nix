{
  stdenv,
  lib,
}:

{
  version,
  ...
}@args:

stdenv.mkDerivation (
  {
    inherit version;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r themes $out/

      runHook postInstall
    '';

    passthru = {
      isHomeAssistantTheme = true;
    }
    // args.passthru or { };

    meta = {
      platforms = lib.platforms.all;
    }
    // args.meta or { };
  }
  // builtins.removeAttrs args [
    "meta"
    "passthru"
  ]
)
