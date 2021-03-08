{ stdenv, lib, fetchurl, protobuf, protobufc, asciidoc, iptables
, xmlto, docbook_xsl, libpaper, libnl, libcap, libnet, pkgconfig
, which, python3, makeWrapper, docbook_xml_dtd_45 }:

stdenv.mkDerivation rec {
  pname = "criu";
  version = "3.15";

  src = fetchurl {
    url    = "https://download.openvz.org/criu/${pname}-${version}.tar.bz2";
    sha256 = "09d0j24x0cyc7wkgi7cnxqgfjk7kbdlm79zxpj8d356sa3rw2z24";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkgconfig docbook_xsl which makeWrapper docbook_xml_dtd_45 python3 python3.pkgs.wrapPython ];
  buildInputs = [ protobuf protobufc asciidoc xmlto libpaper libnl libcap libnet iptables ];
  propagatedBuildInputs = with python3.pkgs; [ python python3.pkgs.protobuf ];

  postPatch = ''
    substituteInPlace ./Documentation/Makefile --replace "2>/dev/null" ""
    substituteInPlace ./Documentation/Makefile --replace "-m custom.xsl" "-m custom.xsl --skip-validation -x ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    substituteInPlace ./criu/Makefile --replace "-I/usr/include/libnl3" "-I${libnl.dev}/include/libnl3"
    substituteInPlace ./Makefile --replace "head-name := \$(shell git tag -l v\$(CRIU_VERSION))" "head-name = ${version}.0"
    ln -sf ${protobuf}/include/google/protobuf/descriptor.proto ./images/google/protobuf/descriptor.proto
  '';

  makeFlags = [ "PREFIX=$(out)" "ASCIIDOC=${asciidoc}/bin/asciidoc" "XMLTO=${xmlto}/bin/xmlto" ];

  outputs = [ "out" "dev" "man" ];

  preBuild = ''
    # No idea why but configure scripts break otherwise.
    export SHELL=""
  '';

  hardeningDisable = [ "stackprotector" "fortify" ];
  # dropping fortify here as well as package uses it by default:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]

  postFixup = ''
    wrapProgram $out/bin/criu \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Userspace checkpoint/restore for Linux";
    homepage    = "https://criu.org";
    license     = licenses.gpl2;
    platforms   = [ "x86_64-linux" ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
