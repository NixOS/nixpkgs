{
  fetchurl,
  stdenv,
  lib,
  buildFHSEnv,
  appimageTools,
  writeShellScript,
  anki,
  undmg,
  zstd,
  cacert,
  commandLineArgs ? [ ],
}:

let
  pname = "anki-bin";
  # Update hashes for both Linux and Darwin!
  version = "24.04.1";

  sources = {
    linux = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-qt6.tar.zst";
      sha256 = "sha256-elUTr0Lumw5bzWbeU74m8e/AxQPNpKXiIOC0Rcgh3AY=";
    };

    # For some reason anki distributes completely separate dmg-files for the aarch64 version and the x86_64 version
    darwin-x86_64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-intel-qt6.dmg";
      sha256 = "sha256-LlHbZ8Yw17Ym11L1lqMibAaV8XWB8oiMFGQxE1PvApI=";
    };
    darwin-aarch64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-apple-qt6.dmg";
      sha256 = "sha256-lMUfIvV4biaOb0ABTZciBP59XY1Ln3tkwphi2oaRu4c=";
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
    inherit (anki.meta)
      license
      homepage
      description
      longDescription
      ;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [ mahmoudk1000 ];
  };

  passthru = { inherit sources; };

  fhsEnvAnki = buildFHSEnv (
    appimageTools.defaultFhsEnvArgs
    // {
      inherit pname version;

      profile = ''
        # anki vendors QT and mixing QT versions usually causes crashes
        unset QT_PLUGIN_PATH
        # anki uses the system ssl cert, without it plugins do not download/update
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
      '';

      # Dependencies of anki
      targetPkgs =
        pkgs:
        (with pkgs; [
          xorg.libxkbfile
          xcb-util-cursor-HEAD
          krb5
          zstd
        ]);

      runScript = writeShellScript "anki-wrapper.sh" ''
        exec ${unpacked}/bin/anki ${lib.strings.escapeShellArgs commandLineArgs} "$@"
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
    }
  );
in

if stdenv.isLinux then
  fhsEnvAnki
else
  stdenv.mkDerivation {
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
