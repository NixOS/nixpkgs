{ stdenv, fetchurl, pkgconfig, perl, lvm2, libaio, gzip, readline, systemd, liburcu, json_c }:

stdenv.mkDerivation rec {
  name = "multipath-tools-${version}";
  version = "0.8.1";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=snapshot;h=refs/tags/${version};sf=tgz";
    sha256 = "0669zl4dpai63dl04lf8vpwnpsff6qf19fifxfc4frawnh699k95";
  };

  postPatch = ''
    substituteInPlace libmultipath/Makefile --replace /usr/include/libdevmapper.h ${lvm2}/include/libdevmapper.h
    sed -i -re '
      s,^( *#define +DEFAULT_MULTIPATHDIR\>).*,\1 "'"$out/lib/multipath"'",
    ' libmultipath/defaults.h
    sed -i -e 's,\$(DESTDIR)/\(usr/\)\?,$(prefix)/,g' \
      kpartx/Makefile libmpathpersist/Makefile
    sed -i -e "s,GZIP = .*, GZIP = gzip -9n -c," \
      Makefile.inc
  '';

  nativeBuildInputs = [ gzip pkgconfig perl ];
  buildInputs = [ systemd lvm2 libaio readline liburcu json_c ];

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
