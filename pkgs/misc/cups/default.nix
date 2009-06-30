{stdenv, fetchurl, zlib, libjpeg, libpng, libtiff, pam, openssl}:

let version = "1.3.10"; in

stdenv.mkDerivation {
  name = "cups-${version}";
  
  src = fetchurl {
    url = "http://ftp.easysw.com/pub/cups/${version}/cups-${version}-source.tar.bz2";
    sha256 = "0rmm1dj8ha8d5c9lpdsfpfyw6l6lnkxl36xlxqdrjnm0lr2sa0cp";
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
