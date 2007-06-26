
pkgs:
pkgs.stdenv.mkDerivation {
  name = "iproute-20070313";

  src = pkgs.fetchurl {
    url = http://ftp.debian.org/debian/pool/main/i/iproute/iproute_20070313.orig.tar.gz;
    sha256 = "1j7cmlr7p9xcg9ys8fhjnynwrp475rbkr2j2c5jqm1xzczw60f9v";
  };

  preConfigure = "for script in $(find . -type f); do sed -e 's@#! /bin/bash@#! /bin/sh@' -i $script; done;";

  makeFlags = " SBINDIR=\\$(out)/sbin CONFDIR=\\$(out)/etc DOCDIR=\\$(out)/doc MANDIR=\\$(out)/man ";
 
  buildInputs = [pkgs.bison pkgs.flex pkgs.db4];
}
