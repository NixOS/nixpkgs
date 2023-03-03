{ lib, fetchurl, tcl, tk, libX11, zlib, makeWrapper, makeDesktopItem }:

tcl.mkTclDerivation rec {
  pname = "scid-vs-pc";
  version = "4.22";

  src = fetchurl {
    url = "mirror://sourceforge/scidvspc/scid_vs_pc-${version}.tgz";
    sha256 = "sha256-PSHDPrfhJI/DyEVQLo8Ckargqf/iUG5PgvUbO/4WNJM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ tk libX11 zlib ];

  prePatch = ''
    sed -i -e '/^ *set headerPath *{/a ${tcl}/include ${tk}/include' \
           -e '/^ *set libraryPath *{/a ${tcl}/lib ${tk}/lib' \
           -e '/^ *set x11Path *{/a ${libX11}/lib/' \
           configure

    sed -i -e '/^ *set scidShareDir/s|\[file.*|"'"$out/share"'"|' \
      tcl/config.tcl
  '';

  # configureFlags = [
  #   "BINDIR=$(out)/bin"
  #   "SHAREDIR=$(out)/share"
  #   "FONTDIR=$(out)/fonts"
  # ];

  preConfigure = ''configureFlags="
    BINDIR=$out/bin
    SHAREDIR=$out/share
    FONTDIR=$out/fonts"
  '';

  patches = [
    ./0001-put-fonts-in-out.patch
  ];

  hardeningDisable = [ "format" ];

  dontPatchShebangs = true;

  # TODO: can this use tclWrapperArgs?
  postFixup = ''
    sed -i -e '1c#!'"$out"'/bin/tcscid' "$out/bin/scidpgn"
    sed -i -e '1c#!${tk}/bin/wish' "$out/bin/sc_remote"
    sed -i -e '1c#!'"$out"'/bin/tkscid' "$out/bin/scid"

    for cmd in $out/bin/* ; do
      wrapProgram "$cmd" \
        --set TK_LIBRARY "${tk}/lib/${tk.libPrefix}"
    done
  '';

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
