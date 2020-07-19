{ stdenv, unzip, ... }:

let
  buildMoodlePlugin = a@{
    name,
    src,
    pluginType,
    configuraPhase ? ":",
    buildPhase ? ":",
    buildInputs ? [ ],
    ...
  }:
  stdenv.mkDerivation (a // {
    name = name;

    inherit pluginType;
    inherit configuraPhase buildPhase;

    buildInputs = [ unzip ] ++ buildInputs;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      mv * $out/

      runHook postInstall
    '';
  });
in {
  inherit buildMoodlePlugin;
}
