{ fetchurl, stdenv, lib, buildFHSUserEnv, appimageTools, writeShellScript, anki, undmg }:

let
  pname = "anki-bin";
  # Update hashes for both Linux and Darwin!
  version = "2.1.47";

  sources = {
    linux = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux.tar.bz2";
      sha256 = "sha256-cObvjXeDUDslfAhMOrlqyjidri6N7xLR2+LRz3hTdfg=";
    };
    darwin = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac.dmg";
      sha256 = "sha256-TwYrI9gSabJ5icOsygtEJRymkrSgCD8jDXMtpaJXgWg=";
    };
  };

  unpacked = stdenv.mkDerivation {
    inherit pname version;

    src = sources.linux;

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

  passthru = { inherit sources; };
in

if stdenv.isLinux then buildFHSUserEnv (appimageTools.defaultFhsEnvArgs // {
  name = "anki";

  runScript = writeShellScript "anki-wrapper.sh" ''
    # Wayland support is broken, disable via ENV variable
    export QT_QPA_PLATFORM=xcb
    exec ${unpacked}/bin/anki
  '';

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -R ${unpacked}/share/applications \
      ${unpacked}/share/man \
      ${unpacked}/share/pixmaps \
      $out/share/
  '';

  inherit meta passthru;
}) else stdenv.mkDerivation {
  inherit pname version passthru;

  src = sources.darwin;

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications/
    cp -a Anki.app $out/Applications/
  '';

  inherit meta;
}
