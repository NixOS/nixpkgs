{stdenv, fetchurl, zlib, libjpeg, libpng, libtiff, pam, openssl}:

let version = "1.4.1"; in

stdenv.mkDerivation {
  name = "cups-${version}";
  
  src = fetchurl {
    url = "http://ftp.easysw.com/pub/cups/${version}/cups-${version}-source.tar.bz2";
    sha256 = "1fnkq993hr8l87x6f7a7wik2spac3f7nn4wksrvwk690r8a6zxng";
  };

  patches =
    [ (fetchurl {
        url = http://www.cups.org/strfiles/3332/0001-Fixed-side_cb-function-declaration-in-usb-unix.c.patch;
        sha256 = "0h8fhhpzp7xngnc428040jv09yvpz5dxb9hw6sv67lnvb03fncnw";
      })
    ];

  buildInputs = [ zlib libjpeg libpng libtiff pam ];

  propagatedBuildInputs = [ openssl ];

  preConfigure = ''
    configureFlags="--localstatedir=/var"
  '';

  preBuild = ''
    makeFlagsArray=(INITDIR=$out/etc/rc.d)
  '';
  
  installFlags =
    [ # Don't try to write in /var at build time.
      "CACHEDIR=$(TMPDIR)/dummy"
      "LOGDIR=$(TMPDIR)/dummy"
      "REQUESTS=$(TMPDIR)/dummy"
      "STATEDIR=$(TMPDIR)/dummy"
      # Work around a Makefile bug.
      "CUPS_PRIMARY_SYSTEM_GROUP=root"
    ];

  meta = {
    homepage = http://www.cups.org/;
    description = "A standards-based printing system for UNIX";
    license = "GPLv2"; # actually LGPL for the library and GPL for the rest
  };
}
