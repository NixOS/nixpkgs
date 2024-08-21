{ lib
, stdenv
, fetchurl
, fetchzip
, appimageTools
}:

let
  pname = "osu-lazer-bin";
  version = "2024.731.0";

  src = {
    aarch64-darwin = fetchzip {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Apple.Silicon.zip";
      hash = "sha256-Z6BIRFkaVBthkZXvewr4lAQCXVNz5SAsm9dR26lZu64=";
      stripRoot = false;
    };
    x86_64-darwin = fetchzip {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Intel.zip";
      hash = "sha256-FWmkcmuMMj4B2dsIlliCuOiQjR+5sAU+b9Jmd+RCmiU=";
      stripRoot = false;
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
      hash = "sha256-6BxHRM7hC+v61BVqSFTzGpi7EyZQeo7kWua0CkrWiPM=";
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
    maintainers = with lib.maintainers; [ gepbird stepbrobd ];
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
      mv -v $out/bin/${pname} $out/bin/osu\!
      install -m 444 -D ${contents}/osu\!.desktop -t $out/share/applications
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ${contents}/osu\!.png $out/share/icons/hicolor/''${i}x$i/apps/osu\!.png
      done
    '';
}
