{ fetchurl, stdenv, lib, buildFHSUserEnv, appimageTools, writeShellScript, anki }:

let
  pname = "anki-bin";
  version = "2.1.36";

  unpacked = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux.tar.bz2";
      sha256 = "01xcjnfs5pfh7v0nkffw2wpl19l6pj9k3kxrcawv3cm42asy0mfz";
    };

    installPhase = ''
      runHook preInstall

      xdg-mime () {
        echo Stubbed!
      }
      export -f xdg-mime

      PREFIX=$out bash install.sh

      runHook postInstall
    '';
  };

  meta = with lib; {
    inherit (anki.meta) license homepage description longDescription;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ atemu ];
  };
in

buildFHSUserEnv (appimageTools.defaultFhsEnvArgs // {
  name = "anki";

  runScript = writeShellScript "anki-wrapper.sh" ''
    exec ${unpacked}/bin/anki
  '';

  inherit meta;
})
