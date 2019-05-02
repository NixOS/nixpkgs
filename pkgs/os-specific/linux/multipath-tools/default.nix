{ stdenv, fetchurl, lvm2, libaio, gzip, readline, systemd, liburcu }:

stdenv.mkDerivation rec {
  name = "multipath-tools-0.6.2";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://git.opensvc.com/";
    sha256 = "159hxvbk9kh1qay9x04w0gsqzg0hkl5yghfc1wi9kv2n5pcwbkpm";
  };

  postPatch = ''
    sed -i -re '
      s,^( *#define +DEFAULT_MULTIPATHDIR\>).*,\1 "'"$out/lib/multipath"'",
    ' libmultipath/defaults.h
    sed -i -e 's,\$(DESTDIR)/\(usr/\)\?,$(prefix)/,g' \
      kpartx/Makefile libmpathpersist/Makefile
    sed -i -e "s,GZIP = .*, GZIP = gzip -9n -c," \
      Makefile.inc
  '';

  nativeBuildInputs = [ gzip ];
  buildInputs = [ systemd lvm2 libaio readline liburcu ];

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "mandir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
    "unitdir=$(out)/lib/systemd/system"
  ];

  meta = with stdenv.lib; {
    description = "Tools for the Linux multipathing driver";
    homepage = http://christophe.varoqui.free.fr/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
