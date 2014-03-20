{ stdenv, fetchurl, protobuf, protobufc, asciidoc, xmlto, utillinux }:

assert stdenv.system == "x86_64-linux";
stdenv.mkDerivation rec {
  name    = "criu-${version}";
  version = "1.2";

  src = fetchurl {
    url    = "http://download.openvz.org/criu/${name}.tar.bz2";
    sha256 = "04xlnqvgbjd5wfmi97m5rr76a3agkz8g96hdyzhc6x8gd52bbg9y";
  };

  enableParallelBuilding = true;
  buildInputs = [ protobuf protobufc asciidoc xmlto ];

  patchPhase = ''
    chmod +w ./scripts/gen-offsets.sh
    substituteInPlace ./scripts/gen-offsets.sh --replace hexdump ${utillinux}/bin/hexdump
  '';

  buildPhase = ''
    make config PREFIX=$out
    make PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/etc/logrotate.d
    make install PREFIX=$out LIBDIR=$out/lib ASCIIDOC=${asciidoc}/bin/asciidoc XMLTO=${xmlto}/bin/xmlto
  '';

  meta = {
    description = "userspace checkpoint/restore for Linux";
    homepage    = "http://criu.org";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
