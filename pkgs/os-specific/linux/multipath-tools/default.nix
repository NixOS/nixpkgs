{ stdenv, fetchurl, pkgconfig, perl, lvm2, libaio, gzip, readline, systemd, liburcu, json_c }:

stdenv.mkDerivation rec {
  pname = "multipath-tools";
  version = "0.8.3";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=snapshot;h=refs/tags/${version};sf=tgz";
    sha256 = "1mgjylklh1cx8px8ffgl12kyc0ln3445vbabd2sy8chq31rpiiq8";
  };

  patches = [
    # fix build with json-c 0.14 https://www.redhat.com/archives/dm-devel/2020-May/msg00261.html
    ./json-c-0.14.patch
  ];

  postPatch = ''
    substituteInPlace libmultipath/Makefile --replace /usr/include/libdevmapper.h ${stdenv.lib.getDev lvm2}/include/libdevmapper.h
    sed -i -re '
      s,^( *#define +DEFAULT_MULTIPATHDIR\>).*,\1 "'"$out/lib/multipath"'",
    ' libmultipath/defaults.h
    sed -i -e 's,\$(DESTDIR)/\(usr/\)\?,$(prefix)/,g' \
      kpartx/Makefile libmpathpersist/Makefile
    sed -i -e "s,GZIP,GZ," \
      $(find * -name Makefile\*)
  '';

  nativeBuildInputs = [ gzip pkgconfig perl ];
  buildInputs = [ systemd lvm2 libaio readline liburcu json_c ];

  makeFlags = [
    "LIB=lib"
    "prefix=$(out)"
    "man8dir=$(out)/share/man/man8"
    "man5dir=$(out)/share/man/man5"
    "man3dir=$(out)/share/man/man3"
    "SYSTEMDPATH=lib"
  ];

  meta = with stdenv.lib; {
    description = "Tools for the Linux multipathing driver";
    homepage = "http://christophe.varoqui.free.fr/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
