{ stdenv, fetchurl, protobuf, protobufc, asciidoc
, xmlto, utillinux, docbook_xsl, libpaper, libnl, libcap, pkgconfig
, python }:

stdenv.mkDerivation rec {
  name    = "criu-${version}";
  version = "2.0";

  src = fetchurl {
    url    = "http://download.openvz.org/criu/${name}.tar.bz2";
    sha256 = "1zqqshslcf503lqip89azp1zz0i8kb7v19b3dyp52izpak62c1z8";
  };

  enableParallelBuilding = true;
  buildInputs = [ protobuf protobufc asciidoc xmlto libpaper libnl libcap pkgconfig python ];

  patchPhase = ''
    chmod +w ./scripts/gen-offsets.sh
    substituteInPlace ./scripts/gen-offsets.sh --replace hexdump ${utillinux}/bin/hexdump
    substituteInPlace ./Documentation/Makefile --replace "2>/dev/null" ""
    substituteInPlace ./Documentation/Makefile --replace "--skip-validation" "--skip-validation -x ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    substituteInPlace ./criu/Makefile --replace "-I/usr/include/libnl3" "-I${libnl.dev}/include/libnl3"
    substituteInPlace ./Makefile --replace "tar-name := $(shell git tag -l v$(CRIU_VERSION))" "tar-name = 2.0" # --replace "-Werror" ""
    ln -sf ${protobuf}/include/google/protobuf/descriptor.proto ./images/google/protobuf/descriptor.proto

    # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
    sed 1i'#include <sys/sysmacros.h>' -i criu/include/util.h
  '';

  buildPhase = "make PREFIX=$out";

  makeFlags = "PREFIX=$(out)";

  hardeningDisable = [ "stackprotector" ];

  installPhase = ''
    mkdir -p $out/etc/logrotate.d
    make install PREFIX=$out LIBDIR=$out/lib ASCIIDOC=${asciidoc}/bin/asciidoc XMLTO=${xmlto}/bin/xmlto
  '';

  meta = with stdenv.lib; {
    description = "Userspace checkpoint/restore for Linux";
    homepage    = https://criu.org;
    license     = licenses.gpl2;
    platforms   = [ "x86_64-linux" ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
