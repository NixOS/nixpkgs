{ lib
, stdenv
, fetchurl
, fetchzip
, appimageTools
}:

let
  pname = "osu-lazer-bin";
  version = "2023.1229.0";

  src = {
    aarch64-darwin = fetchzip {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Apple.Silicon.zip";
      hash = "sha256-aZp8pVeCxmaAyWYnBg7w8sPMXy+L2UGRk3NvG/VsxYI=";
      stripRoot = false;
    };
    x86_64-darwin = fetchzip {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.app.Intel.zip";
      hash = "sha256-Xle/WcWg+lYA+DxQmE4Kzn1pJTa+HrM13utXqdK8ZZY=";
      stripRoot = false;
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
      hash = "sha256-lRdRPwa6xix5Nvt3szPeposmqU8D826iFmE6S1uPBF8=";
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
    maintainers = with lib.maintainers; [ delan gepbird spacefault stepbrobd ];
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
