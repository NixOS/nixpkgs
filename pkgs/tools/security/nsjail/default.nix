{ stdenv, fetchFromGitHub, autoconf, bison, flex, libtool, pkgconfig, which
, libnl, protobuf, protobufc, shadow
}:

stdenv.mkDerivation rec {
  name = "nsjail-${version}";
  version = "2.8";

  src = fetchFromGitHub {
    owner           = "google";
    repo            = "nsjail";
    rev             = version;
    fetchSubmodules = true;
    sha256          = "0cgycj0cz74plmz4asxryqprg6mkzpmnxzqbfsp1wwackinxq5fq";
  };

  postPatch = ''
    substituteInPlace user.cc \
      --replace "/usr/bin/newgidmap" "${shadow}/bin/newgidmap" \
      --replace "/usr/bin/newuidmap" "${shadow}/bin/newuidmap"
  '';

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
