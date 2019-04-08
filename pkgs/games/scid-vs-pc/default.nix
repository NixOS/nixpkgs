{ stdenv, fetchurl, tcl, tk, libX11, zlib, makeWrapper, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "scid-vs-pc-${version}";
  version = "4.20";

  src = fetchurl {
    url = "mirror://sourceforge/scidvspc/scid_vs_pc-${version}.tgz";
    sha256 = "1mpardcxp5hsmhyla1cjqf4aalacs3v6xkf1zyjz16g1m3gh05lm";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ tcl tk libX11 zlib ];

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

  postFixup = ''
    sed -i -e '1c#!'"$out"'/bin/tcscid' "$out/bin/scidpgn"
    sed -i -e '1c#!${tk}/bin/wish' "$out/bin/sc_remote"
    sed -i -e '1c#!'"$out"'/bin/tkscid' "$out/bin/scid"

    for cmd in $out/bin/* ; do
      wrapProgram "$cmd" \
        --set TCLLIBPATH "${tcl}/${tcl.libdir}" \
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
    categories = "Game;BoardGame;";
  };

  meta = with stdenv.lib; {
    description = "Chess database with play and training functionality";
    homepage = http://scidvspc.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.paraseba ];
    platforms = stdenv.lib.platforms.linux;
  };
}

