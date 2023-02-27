{ fetchurl, stdenv, lib, buildFHSUserEnv, appimageTools, writeShellScript, anki, undmg, zstd }:

let
  pname = "anki-bin";
  # Update hashes for both Linux and Darwin!
  version = "2.1.54";

  sources = {
    linux = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-qt6.tar.zst";
      sha256 = "sha256-NFhgVd4ctEsh7iaSZ9v0OMszd81H41eq+y+FRIhcCtE=";
    };

    # For some reason anki distributes completely separate dmg-files for the aarch64 version and the x86_64 version
    darwin-x86_64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-intel-qt6.dmg";
      sha256 = "sha256-kus59Z9Oe4sbAlF4szeg751hlSEUR0ijKz4rjfHEWgA=";
    };
    darwin-aarch64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-apple-qt6.dmg";
      sha256 = "sha256-ROIpGB3W21ttWj+cRkf0rpLFrO4LR6+ZyGRsalz5J+E=";
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
    maintainers = with maintainers; [ atemu ];
  };

  passthru = { inherit sources; };

  fhsUserEnvAnki = buildFHSUserEnv (appimageTools.defaultFhsEnvArgs // {
    name = "anki";

    # Dependencies of anki
    targetPkgs = pkgs: (with pkgs; [ xorg.libxkbfile krb5 ]);

    runScript = writeShellScript "anki-wrapper.sh" ''
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
  });

  fhsUserEnvAnkiWithVersion = fhsUserEnvAnki.overrideAttrs (oldAttrs: {
    # buildFHSUserEnv doesn't have an easy way to set the version of the
    # resulting derivation, so we manually override it here.  This makes
    # it clear to end users the version of anki-bin.  Without this, users
    # might assume anki-bin is an old version of Anki.
    name = "${pname}-${version}";
  });
in

if stdenv.isLinux then fhsUserEnvAnkiWithVersion
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
