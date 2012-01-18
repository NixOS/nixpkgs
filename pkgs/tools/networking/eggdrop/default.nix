{stdenv, fetchurl, tcl}:

stdenv.mkDerivation {
  name = "eggdrop-1.6.19";

  src = fetchurl {
    url = ftp://ftp.eggheads.org/pub/eggdrop/GNU/1.6/eggdrop1.6.19+ctcpfix.tar.gz;
    sha256 = "1lpa6sqwizn8y30i14559j3427vi743pmsxjq9g70x4m71hmshvi";
  };

  buildInputs = [tcl]; 

  preConfigure = ''
    prefix=$out/eggdrop
    mkdir -p $prefix
  '';

  postConfigure = ''
    make config
  '';

  configureFlags = "--with-tcllib=${tcl}/lib/libtcl8.5.so --with-tclinc=${tcl}/include/tcl.h";
}
