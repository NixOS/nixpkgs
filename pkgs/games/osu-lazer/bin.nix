{ lib
, stdenv
, fetchurl
, fetchzip
, appimageTools
}:

let
  pname = "osu-lazer-bin";
  version = "2023.305.0";
  name = "${pname}-${version}";

  file = {
    aarch64-darwin = "osu.app.Apple.Silicon.zip";
    x86_64-darwin = "osu.app.Intel.zip";
    x86_64-linux = "osu.AppImage";
  }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

  fileHash = {
    aarch64-darwin = "sha256-vfDEEU+InD5uIc1QKceM2SN1GlWV93DySn3ik1MSYf4=";
    x86_64-darwin = "sha256-dK+qqwBzuPXHqQk8U3TpWQBWEz+8S9GHShVwTTq2BBQ=";
    x86_64-linux = "sha256-W3XJ7HtJM5iFI8OOTTu8IBHMerZSCETHMemkoTislK8=";
  }.${stdenv.system};

  linux = appimageTools.wrapType2 rec {
    inherit name pname version meta;

    src = fetchurl {
      url = "https://github.com/ppy/osu/releases/download/${version}/${file}";
      sha256 = fileHash;
    };

    extraPkgs = pkgs: with pkgs; [ icu ];

    extraInstallCommands =
      let contents = appimageTools.extract { inherit pname version src; };
      in
      ''
        mv -v $out/bin/${pname}-${version} $out/bin/osu\!
        install -m 444 -D ${contents}/osu\!.desktop -t $out/share/applications
        for i in 16 32 48 64 96 128 256 512 1024; do
          install -D ${contents}/osu\!.png $out/share/icons/hicolor/''${i}x$i/apps/osu\!.png
        done
      '';
  };

  darwin = stdenv.mkDerivation rec {
    inherit name pname version meta;

    src = fetchzip {
      url = "https://github.com/ppy/osu/releases/download/${version}/${file}";
      sha256 = fileHash;
      stripRoot = false;
    };

    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      APP_DIR="$out/Applications"
      mkdir -p "$APP_DIR"
      cp -r . "$APP_DIR"
      runHook postInstall
    '';
  };

  meta = with lib; {
    description = "Rhythm is just a *click* away (AppImage version for score submission and multiplayer, and binary distribution for Darwin systems)";
    homepage = "https://osu.ppy.sh";
    license = with licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ delan stepbrobd ];
    mainProgram = "osu!";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
  };
in
if stdenv.isDarwin
then darwin
else linux
