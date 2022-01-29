{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, wrapGAppsHook
, gobject-introspection
, gdk-pixbuf
, jre
, androidenv
}:

stdenv.mkDerivation rec {
  pname = "agi";
  version = "2.2.0-dev-20220120";

  src = fetchzip {
    url = "https://github.com/google/agi-dev-releases/releases/download/v${version}/agi-${version}-linux.zip";
    sha256 = "sha256-0f17CAANxomtx1fvhj+mI6k4IqwIimmcTSTXZGbbWDY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook
    gdk-pixbuf
    gobject-introspection
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib}
    cp ./{agi,gapis,gapir,gapit,device-info} $out/bin
    cp lib/gapic.jar $out/lib
    wrapProgram $out/bin/agi \
      --add-flags "--vm ${jre}/bin/java" \
      --add-flags "--jar $out/lib/gapic.jar" \
      --add-flags "--adb ${androidenv.androidPkgs_9_0.platform-tools}/bin/adb"
    for i in 16 32 48 64 96 128 256 512 1024; do
      install -D ${src}/icon.png $out/share/icons/hicolor/''${i}x$i/apps/agi.png
    done
    runHook postInstall
  '';

  desktopItems = [(makeDesktopItem {
    name = "agi";
    desktopName = "Android GPU Inspector";
    exec = "$out/bin/agi";
    icon = "agi";
    type = "Application";
    categories = "Development;Debugger;Graphics;3DGraphics";
    terminal = "false";
  })];

  meta = with lib; {
    homepage = "https://github.com/google/agi/";
    description = "Android GPU Inspector";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.ivar ];
  };
}
