{
  lib,
  fetchurl,
  fetchpatch,
  tcl,
  tk,
}:

tcl.mkTclDerivation {
  version = "8.4.3";
  pname = "tix";
  src = fetchurl {
    url = "mirror://sourceforge/tix/tix/8.4.3/Tix8.4.3-src.tar.gz";
    hash = "sha256-Vi8ED/dlfhC1z/wsQZNfGlPGQC6z1fMYkRPXNP1sA8s=";
  };
  patches = [
    (fetchpatch {
      name = "tix-8.4.3-tcl8.5.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-tcltk/tix/files/tix-8.4.3-tcl8.5.patch?id=56bd759df1d0c750a065b8c845e93d5dfa6b549d";
      hash = "sha256-cpsvacSWedHZRRBsTu3zDnqR+NUg/P6kvTgD3Dur+HM=";
    })
    # Remove duplicated definition of XLowerWindow
    ./duplicated-xlowerwindow.patch
    # Fix incompatible function pointer conversions and implicit definition of `panic`.
    # `panic` is just `Tcl_Panic`, but it is not defined on Darwin due to a conflict with `mach/mach.h`.
    ./fix-clang16.patch
  ]
  ++ lib.optional (tcl.release == "8.6") (fetchpatch {
    name = "tix-8.4.3-tcl8.6.patch";
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-tcltk/tix/files/tix-8.4.3-tcl8.6.patch?id=56bd759df1d0c750a065b8c845e93d5dfa6b549d";
    hash = "sha256-ZuSzljvvHeW3ewQ/ui6ZfFl9QzQqppXJDP3ILgQFX8k=";
  });
  buildInputs = [ tk ];
  # the configure script expects to find the location of the sources of
  # tcl and tk in {tcl,tk}Config.sh
  # In fact, it only needs some private headers. We copy them in
  # the private_headers folders and trick the configure script into believing
  # the sources are here.
  preConfigure = ''
    mkdir -p private_headers/generic
    < ${tcl}/lib/tclConfig.sh sed "s@TCL_SRC_DIR=.*@TCL_SRC_DIR=private_headers@" > tclConfig.sh
    < ${tk}/lib/tkConfig.sh sed "s@TK_SRC_DIR=.*@TK_SRC_DIR=private_headers@" > tkConfig.sh
    for i in ${tcl}/include/* ${tk.dev}/include/*; do
      ln -s $i private_headers/generic;
    done;
  '';
  addTclConfigureFlags = false;
  configureFlags = [
    "--with-tclconfig=."
    "--with-tkinclude=${tk.dev}/include"
    "--with-tkconfig=."
    "--libdir=\${prefix}/lib"
  ];

  meta = {
    description = "Widget library for Tcl/Tk";
    homepage = "https://tix.sourceforge.net/";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      bsd2 # tix
      gpl2 # patches from portage
    ];
  };
}
