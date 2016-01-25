{ stdenv, fetchurl, lvm2, libaio, gzip, readline, udev }:

stdenv.mkDerivation rec {
  name = "multipath-tools-0.5.0";

  src = fetchurl {
    url = "http://christophe.varoqui.free.fr/multipath-tools/${name}.tar.bz2";
    sha256 = "1yd6l1l1c62xjr1xnij2x49kr416anbgfs4y06r86kp9hkmz2g7i";
  };

  postPatch = ''
    sed -i -re '
      s,^( *#define +DEFAULT_MULTIPATHDIR\>).*,\1 "'"$out/lib/multipath"'",
    ' libmultipath/defaults.h
    sed -i -e 's,\$(DESTDIR)/\(usr/\)\?,$(prefix)/,g' \
      kpartx/Makefile libmpathpersist/Makefile
  '';

  nativeBuildInputs = [ gzip ];
  buildInputs = [ udev lvm2 libaio readline ];

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "mandir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
    "unitdir=$(out)/lib/systemd/system"
  ];

  meta = {
    description = "Tools for the Linux multipathing driver";
    homepage = http://christophe.varoqui.free.fr/;
    platforms = stdenv.lib.platforms.linux;
  };
}
