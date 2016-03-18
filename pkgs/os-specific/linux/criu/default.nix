{ stdenv, fetchurl, protobuf, protobufc, asciidoc
, xmlto, utillinux, docbook_xsl, libpaper }:

stdenv.mkDerivation rec {
  name    = "criu-${version}";
  version = "1.3-rc2";

  src = fetchurl {
    url    = "http://download.openvz.org/criu/${name}.tar.bz2";
    sha256 = "1h9ii91aq8cja22j3520vg3qb3y9h6c064s4115s2ldylm8jmi0s";
  };

  enableParallelBuilding = true;
  buildInputs = [ protobuf protobufc asciidoc xmlto libpaper ];

  patchPhase = ''
    chmod +w ./scripts/gen-offsets.sh
    substituteInPlace ./scripts/gen-offsets.sh --replace hexdump ${utillinux}/bin/hexdump
    substituteInPlace ./Documentation/Makefile --replace "2>/dev/null" ""
    substituteInPlace ./Documentation/Makefile --replace "--skip-validation" "--skip-validation -x ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    substituteInPlace ./Makefile --replace "-Werror" ""
  '';

  configurePhase = "make config PREFIX=$out";
  buildPhase     = "make PREFIX=$out";

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
