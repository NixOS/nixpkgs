{ appimageTools, lib, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "osu-lazer-bin";
  version = "2023.207.0";

  src = fetchurl {
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
    sha256 = "sha256-xJQcqNV/Pr3gEGStczc3gv8AYrEKFsAo2g4WtA59fwk=";
  };

  extraPkgs = pkgs: with pkgs; [ icu ];

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      mv -v $out/bin/${pname}-${version} $out/bin/osu\!
      install -m 444 -D ${contents}/osu\!.desktop -t $out/share/applications
      for i in 16 32 48 64 96 128 256 512 1024; do
        install -D ${contents}/osu\!.png $out/share/icons/hicolor/''${i}x$i/apps/osu\!.png
      done
    '';

  meta = with lib; {
    description = "Rhythm is just a *click* away (AppImage version for score submission and multiplayer)";
    homepage = "https://osu.ppy.sh";
    license = with licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ maintainers.delan ];
    mainProgram = "osu!";
    platforms = [ "x86_64-linux" ];
  };
}
