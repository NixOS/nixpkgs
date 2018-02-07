{ stdenv, fetchFromGitHub, autoconf, pkgconfig, libtool
, bison, flex, libnl, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "nsjail-${version}";
  version = "2.2";

  src = fetchFromGitHub {
    owner           = "google";
    repo            = "nsjail";
    rev             = version;
    fetchSubmodules = true;
    sha256          = "11323j5wd02nm8ibvzbzq7dla70bmcldc71lv5bpk4x7h64ai14v";
  };

  nativeBuildInputs = [ autoconf libtool pkgconfig ];
  buildInputs = [ bison flex libnl protobuf protobufc ];
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    install nsjail $out/bin/
    install nsjail.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "A light-weight process isolation tool, making use of Linux namespaces and seccomp-bpf syscall filters";
    homepage    = http://nsjail.com/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ bosu c0bw3b ];
    platforms   = platforms.linux;
  };
}
