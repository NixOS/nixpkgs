{ stdenv, fetchurl, protobuf, protobufc, asciidoc
, xmlto, docbook_xsl, libpaper, libnl, libcap, libnet, pkgconfig
, python }:

stdenv.mkDerivation rec {
  name    = "criu-${version}";
  version = "3.9";

  src = fetchurl {
    url    = "https://download.openvz.org/criu/${name}.tar.bz2";
    sha256 = "0l71lmklr42pc2bj37pkp7y8va8bx42n9f6i4q4idsx4wrdd75fx";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig docbook_xsl ];
  buildInputs = [ protobuf protobufc asciidoc xmlto libpaper libnl libcap libnet python ];

  postPatch = ''
    substituteInPlace ./Documentation/Makefile --replace "2>/dev/null" ""
    substituteInPlace ./Documentation/Makefile --replace "-m custom.xsl" "-m custom.xsl --skip-validation -x ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    substituteInPlace ./criu/Makefile --replace "-I/usr/include/libnl3" "-I${libnl.dev}/include/libnl3"
    substituteInPlace ./Makefile --replace "head-name := \$(shell git tag -l v\$(CRIU_VERSION))" "head-name = ${version}.0"
    ln -sf ${protobuf}/include/google/protobuf/descriptor.proto ./images/google/protobuf/descriptor.proto
  '';

  buildPhase = "make PREFIX=$out";

  makeFlags = "PREFIX=$(out)";

  hardeningDisable = [ "stackprotector" "fortify" ];
  # dropping fortify here as well as package uses it by default:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]

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
