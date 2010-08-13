{fetchurl, stdenv, flex, bison, db4}:

stdenv.mkDerivation rec {
  name = "iproute2-2.6.29-1";

  src = fetchurl {
    url = "http://devresources.linux-foundation.org/dev/iproute2/download/${name}.tar.bz2";
    sha256 = "16zvhdzv7yqyvmwxyqa6shzsld6r0wpnk37dig69sk20wpzv1zqk";
  };
 
  preConfigure =
    ''
      patchShebangs ./configure
    '';

  makeFlags = "DESTDIR= LIBDIR=$(out)/lib SBINDIR=$(out)/sbin CONFDIR=$(out)/etc DOCDIR=$(out)/share/doc MANDIR=$(out)/share/man";

  buildInputs = [bison flex db4];

  meta = {
    homepage =
      http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2;
  };
}
