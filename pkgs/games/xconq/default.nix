{ stdenv, fetchurl, cpio, xproto, libX11, libXmu, libXaw, libXt, tcl, tk
, libXext, fontconfig, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  baseName = "xconq";
  version = "7.5.0-0pre.0.20050612";

  src = fetchurl {
    url = "mirror://sourceforge/project/${baseName}/${baseName}/${name}/${name}.tar.gz";
    sha256 = "1za78yx57mgwcmmi33wx3533yz1x093dnqis8q2qmqivxav51lca";
  };

  buildInputs = [ cpio xproto libX11 libXmu libXaw libXt tcl tk libXext
    fontconfig makeWrapper ];

  configureFlags = [
    "--enable-alternate-scoresdir=scores"
    "--with-tclconfig=${tcl}/lib"
    "--with-tkconfig=${tk}/lib"
  ];

  hardeningDisable = [ "format" ];

  patchPhase = ''
    # Fix Makefiles
    find . -name 'Makefile.in' -exec sed -re 's@^        ( *)(cd|[&][&])@	\1\2@' -i '{}' ';'
    find . -name 'Makefile.in' -exec sed -e '/chown/d; /chgrp/d' -i '{}' ';'
    sed -e '/^			* *[$][(]tcltkdir[)]\/[*][.][*]/d' -i tcltk/Makefile.in

    # Fix C files
    sed -re 's@[(]int[)]color@(long)color@' -i tcltk/tkmap.c
    sed -re '/unitp = view_unit[(]uview[)]/aelse *unitp = NULL\;' -i tcltk/tkmap.c

    # Fix TCL files
    sed -re 's@MediumBlue@LightBlue@g' -i tcltk/tkconq.tcl
  '';

  postInstall = ''
    for file in $out/bin/*; do
      wrapProgram $file --prefix TCLLIBPATH ' ' "${tk}/lib"
    done
  '';

  meta = with stdenv.lib; {
    description = "A programmable turn-based strategy game";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
