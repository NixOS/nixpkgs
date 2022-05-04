{ lib, stdenv, fetchurl, cpio, xorgproto, libX11, libXmu, libXaw, libXt, tcl, tk
, libXext, fontconfig, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xconq";
  version = "7.5.0-0pre.0.20050612";

  src = fetchurl {
    url = "mirror://sourceforge/project/xconq/xconq/xconq-${version}/xconq-${version}.tar.gz";
    sha256 = "1za78yx57mgwcmmi33wx3533yz1x093dnqis8q2qmqivxav51lca";
  };

  buildInputs = [ cpio xorgproto libX11 libXmu libXaw libXt tcl tk libXext
    fontconfig makeWrapper ];

  configureFlags = [
    "--enable-alternate-scoresdir=scores"
    "--with-tclconfig=${tcl}/lib"
    "--with-tkconfig=${tk}/lib"
  ];

  CXXFLAGS = " --std=c++11 ";

  hardeningDisable = [ "format" ];

  patchPhase = ''
    # Fix Makefiles
    find . -name 'Makefile.in' -exec sed -re 's@^        ( *)(cd|[&][&])@	\1\2@' -i '{}' ';'
    find . -name 'Makefile.in' -exec sed -e '/chown/d; /chgrp/d' -i '{}' ';'
    # do not set sticky bit in nix store
    find . -name 'Makefile.in' -exec sed -e 's/04755/755/g' -i '{}' ';'
    sed -e '/^			* *[$][(]tcltkdir[)]\/[*][.][*]/d' -i tcltk/Makefile.in

    # Fix C files
    sed -re 's@[(]int[)]color@(long)color@' -i tcltk/tkmap.c
    sed -re '/unitp = view_unit[(]uview[)]/aelse *unitp = NULL\;' -i tcltk/tkmap.c
    sed -re 's@BMAP_BYTE char@BMAP_BYTE unsigned char@' -i kernel/ui.h

    # Fix TCL files
    sed -re 's@MediumBlue@LightBlue@g' -i tcltk/tkconq.tcl
  '';

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --prefix TCLLIBPATH ' ' "${tk}/lib"
    done
  '';

  meta = with lib; {
    description = "A programmable turn-based strategy game";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
