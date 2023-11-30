{ lib
, stdenv
, fetchurl
, fetchzip
, appimageTools
}:

let
  pname = "osu-lazer-bin";
  version = "2023.1130.0";

  src = {
    aarch64-darwin = fetchzip {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Apple.Silicon.zip";
      hash = "sha256-7lQVc517QEtQDdSF5FxR+kgw1TVpr8H3whzURelABIY=";
      stripRoot = false;
    };
    x86_64-darwin = fetchzip {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Intel.zip";
      hash = "sha256-BOpW8QP4TLKzdTDnjjT/t4k+3Q2w2MWA0IDnXH+/mBU=";
      stripRoot = false;
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
      hash = "sha256-dQuyKjCZaIl3uaI81qRMt5NzBxfmyROVbJrVAqzuZxg=";
    };
  }.${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

  meta = {
    description = "Rhythm is just a *click* away (AppImage version for score submission and multiplayer, and binary distribution for Darwin systems)";
    homepage = "https://osu.ppy.sh";
    license = with lib.licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ delan spacefault stepbrobd ];
    mainProgram = "osu!";
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
  };

  passthru.updateScript = ./update-bin.sh;
in
if stdenv.isDarwin
then stdenv.mkDerivation {
  inherit pname version src meta passthru;

  installPhase = ''
    runHook preInstall
    APP_DIR="$out/Applications"
    mkdir -p "$APP_DIR"
    cp -r . "$APP_DIR"
    runHook postInstall
  '';
}
else appimageTools.wrapType2 {
  inherit pname version src meta passthru;

  extraPkgs = pkgs: with pkgs; [ icu ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      mv -v $out/bin/${pname}-${version} $out/bin/osu\!
      install -m 444 -D ${contents}/osu\!.desktop -t $out/share/applications
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ${contents}/osu\!.png $out/share/icons/hicolor/''${i}x$i/apps/osu\!.png
      done
    '';
}
