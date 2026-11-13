{ stdenv, unzip, ... }:

let
  buildMoodlePlugin =
    a@{
      name,
      src,
      pluginType,
      configurePhase ? ":",
      buildPhase ? ":",
      buildInputs ? [ ],
      nativeBuildInputs ? [ ],
      ...
    }:
    stdenv.mkDerivation (
      a
      // {
        name = name;

        inherit pluginType;
        inherit configurePhase buildPhase buildInputs;

        nativeBuildInputs = [ unzip ] ++ nativeBuildInputs;

        installPhase = ''
          runHook preInstall

          mkdir -p "$out"
          mv * $out/

          runHook postInstall
        '';
      }
    );
in
{
  inherit buildMoodlePlugin;
}
