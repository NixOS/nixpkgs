{ lib
, stdenv
, fetchurl
, fetchzip
, appimageTools
}:

let
  pname = "osu-lazer-bin";
  version = "2023.1008.1";
  name = "${pname}-${version}";

  osu-lazer-bin-src = {
    aarch64-darwin = {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Apple.Silicon.zip";
      sha256 = "sha256-eL5UVZqAH7Ta442xIDjaOPu3NXJmck+lS+BoD/qnOMs=";
    };
    x86_64-darwin = {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Intel.zip";
      sha256 = "sha256-x/HL73Fao11GVj7uMFpx4uOKv8Gmiy1PEgee2sP1fvg=";
    };
    x86_64-linux = {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
      sha256 = "sha256-QqyymPkeRcedK75O9S0zO8DrUmPKuC7Mp4SbXT+QM9I=";
    };
  }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

  linux = appimageTools.wrapType2 rec {
    inherit name pname version meta;

    src = fetchurl (osu-lazer-bin-src);

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

    src = fetchzip (osu-lazer-bin-src // { stripRoot = false; });

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

  passthru.updateScript = ./update-bin.sh;
in
if stdenv.isDarwin
then darwin
else linux

