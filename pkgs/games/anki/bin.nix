{ fetchurl, stdenv, lib, buildFHSUserEnv, appimageTools, writeShellScript, anki, undmg }:

let
  pname = "anki-bin";
  # Update hashes for both Linux and Darwin!
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ atemu ];
  };
in

if stdenv.isLinux then buildFHSUserEnv (appimageTools.defaultFhsEnvArgs // {
  name = "anki";

  runScript = writeShellScript "anki-wrapper.sh" ''
    # Wayland support is broken, disable via ENV variable
    export QT_QPA_PLATFORM=xcb
    exec ${unpacked}/bin/anki
  '';

  inherit meta;
}) else stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac.dmg";
    sha256 = "1i6iidm5h8r9g801mvqxi2av03qdw3lr28056fv5ixnb5dq2wqim";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications/
    cp -a Anki.app $out/Applications/
  '';

  inherit meta;
}
