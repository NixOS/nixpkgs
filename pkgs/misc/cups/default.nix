{stdenv, fetchurl, zlib, libjpeg, libpng, libtiff, pam, openssl}:

stdenv.mkDerivation {
  name = "cups-1.3.9";
  
  src = fetchurl {
    url = http://ftp.easysw.com/pub/cups/1.3.9/cups-1.3.9-source.tar.bz2;
    sha256 = "0svb5alfsj9bfraw0yb9i92g5hc9h36m9xfipvi1pxdwp2s6m19q";
  };

  buildInputs = [zlib libjpeg libpng libtiff pam openssl];

  preConfigure = ''
    configureFlags="--localstatedir=/var"
  '';

  preBuild = ''
    makeFlagsArray=(INITDIR=$out/etc/rc.d)
  '';

  # Awful hack: CUPS' `make install' wants to write in /var, but it
  # can't.  So redirect it with a BUILDROOT (=DESTDIR).
  preInstall = ''
    installFlagsArray=(BUILDROOT=$out/destdir)
  '';

  postInstall = ''
    mv $out/destdir/$out/* $out
    rm -rf $out/destdir
  ''; # */

  meta = {
    homepage = http://www.cups.org/;
    description = "A standards-based printing system for UNIX";
  };
}
