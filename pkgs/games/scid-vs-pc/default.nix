{ lib, fetchurl, tcl, tk, libX11, zlib, makeWrapper, which, makeDesktopItem }:

tcl.mkTclDerivation rec {
  pname = "scid-vs-pc";
  version = "4.24";

  src = fetchurl {
    url = "mirror://sourceforge/scidvspc/scid_vs_pc-${version}.tgz";
    hash = "sha256-x4Ljn1vaXrue16kUofWAH2sDNYC8h3NvzFjffRo0EhA=";
  };

  postPatch = ''
    substituteInPlace configure Makefile.conf \
      --replace "~/.fonts" "$out/share/fonts/truetype/Scid" \
      --replace "which fc-cache" "false"
  '';

  nativeBuildInputs = [ makeWrapper which ];
  buildInputs = [ tk libX11 zlib ];

  configureFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "SHAREDIR=${placeholder "out"}/share"
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications/

    install -D icons/scid.png "$out"/share/icons/hicolor/128x128/apps/scid.png
  '';

  desktopItem = makeDesktopItem {
    name = "scid-vs-pc";
    desktopName = "Scid vs. PC";
    genericName = "Chess Database";
    comment = meta.description;
    icon = "scid";
    exec = "scid";
    categories = [ "Game" "BoardGame" ];
  };

  meta = with lib; {
    description = "Chess database with play and training functionality";
    homepage = "https://scidvspc.sourceforge.net/";
    license = lib.licenses.gpl2;
    maintainers = [ maintainers.paraseba ];
    platforms = lib.platforms.linux;
  };
}
