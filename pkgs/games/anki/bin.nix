{ fetchurl, stdenv, lib, buildFHSEnv, appimageTools, writeShellScript, anki, undmg, zstd, commandLineArgs ? [] }:

let
  pname = "anki-bin";
  # Update hashes for both Linux and Darwin!
  version = "23.10.1";

  sources = {
    linux = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-qt6.tar.zst";
      sha256 = "sha256-Kv0SH+bLnBSM/tYHe2kEJc4n7izZTBNWQs2nm/teLEU=";
    };

    # For some reason anki distributes completely separate dmg-files for the aarch64 version and the x86_64 version
    darwin-x86_64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-intel-qt6.dmg";
      sha256 = "sha256-MSlKsEv4N/H7G1bUOBlPBXerpHIW32P6Va02aRq1+54=";
    };
    darwin-aarch64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-apple-qt6.dmg";
      sha256 = "sha256-jEm9WJBXx77KpldzBuxK1Pu6VGiARZPnRmMhEjZdm1I=";
    };
  };

  unpacked = stdenv.mkDerivation {
    inherit pname version;

    nativeBuildInputs = [ zstd ];
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
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = with maintainers; [ mahmoudk1000 ];
  };

  passthru = { inherit sources; };

  fhsEnvAnki = buildFHSEnv (appimageTools.defaultFhsEnvArgs // {
    inherit pname version;
    name = null; # Appimage sets it to "appimage-env"

    # Dependencies of anki
    targetPkgs = pkgs: (with pkgs; [ xorg.libxkbfile xcb-util-cursor-HEAD krb5 ]);

    runScript = writeShellScript "anki-wrapper.sh" ''
      exec ${unpacked}/bin/anki ${ lib.strings.escapeShellArgs commandLineArgs } "$@"
    '';

    extraInstallCommands = ''
      ln -s ${pname} $out/bin/anki

      mkdir -p $out/share
      cp -R ${unpacked}/share/applications \
        ${unpacked}/share/man \
        ${unpacked}/share/pixmaps \
        $out/share/
    '';

    inherit meta passthru;
  });
in

if stdenv.isLinux then fhsEnvAnki
else stdenv.mkDerivation {
  inherit pname version passthru;

  src = if stdenv.isAarch64 then sources.darwin-aarch64 else sources.darwin-x86_64;

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications/
    cp -a Anki.app $out/Applications/
  '';

  inherit meta;
}
