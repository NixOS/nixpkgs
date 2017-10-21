{ stdenv, fetchFromGitHub, autoconf, pkgconfig, libtool
, bison, flex, libnl, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "nsjail-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner           = "google";
    repo            = "nsjail";
    rev             = version;
    fetchSubmodules = true;
    sha256          = "1wkhy86d0vgzngdvv593yhcghjh63chb8s67v891zll6bwgwg5h2";
  };

  nativeBuildInputs = [ autoconf libtool pkgconfig ];
  buildInputs = [ bison flex libnl protobuf protobufc ];

  installPhase = ''
    mkdir -p $out/bin
    cp nsjail $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A light-weight process isolation tool, making use of Linux namespaces and seccomp-bpf syscall filters";
    homepage    = http://nsjail.com/;
    license     = licenses.apsl20;
    maintainers = [ maintainers.bosu ];
    platforms   = platforms.linux;
  };
}
