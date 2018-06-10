{ stdenv, fetchurl, tcl, tk, libX11, zlib, makeWrapper }:

stdenv.mkDerivation rec {
  name = "scid-vs-pc-${version}";
  version = "4.18.1";

  src = fetchurl {
    url = "mirror://sourceforge/scidvspc/scid_vs_pc-4.18.1.tgz";
    sha256 = "01nd88g3wh3avz1yk9fka9zf20ij8dlnpwzz8gnx78i5b06cp459";
  };

  buildInputs = [ tcl tk libX11 zlib makeWrapper ];

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
    for cmd in sc_addmove sc_eco sc_epgn scidpgn \
               sc_import sc_spell sc_tree spliteco
    do
      sed -i -e '1c#!'"$out"'/bin/tcscid' "$out/bin/$cmd"
    done

    sed -i -e '1c#!${tk}/bin/wish' "$out/bin/sc_remote"
    sed -i -e '1c#!'"$out"'/bin/tkscid' "$out/bin/scid"

    for cmd in $out/bin/*
    do
      wrapProgram "$cmd" \
        --set TCLLIBPATH "${tcl}/${tcl.libdir}" \
        --set TK_LIBRARY "${tk}/lib/${tk.libPrefix}"
    done
  '';


  meta = with stdenv.lib; {
    description = "Chess database with play and training functionality";
    homepage = http://scidvspc.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.paraseba ];
    platforms = stdenv.lib.platforms.linux;
  };
}

