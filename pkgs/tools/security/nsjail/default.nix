{ stdenv, fetchFromGitHub, autoconf, bison, flex, libtool, pkgconfig, which
, libnl, protobuf, protobufc }:

stdenv.mkDerivation rec {
  name = "nsjail-${version}";
  version = "2.7";

  src = fetchFromGitHub {
    owner           = "google";
    repo            = "nsjail";
    rev             = version;
    fetchSubmodules = true;
    sha256          = "13s1bi2b80rlwrgls1bx4bk140qhncwdamm9q51jd677s0i3xg3s";
  };

  nativeBuildInputs = [ autoconf bison flex libtool pkgconfig which ];
  buildInputs = [ libnl protobuf protobufc ];
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
