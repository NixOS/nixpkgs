{ lib, stdenv, fetchFromGitHub, autoconf, bison, flex, libtool, pkg-config, which
, libnl, protobuf, protobufc, shadow
}:

stdenv.mkDerivation rec {
  pname = "nsjail";
  version = "3.0"; # Bumping? Remove the bison patch.

  src = fetchFromGitHub {
    owner           = "google";
    repo            = "nsjail";
    rev             = version;
    fetchSubmodules = true;
    sha256          = "1w6x8xcrs0i1y3q41gyq8z3cq9x24qablklc4jiydf855lhqn4dh";
  };

  nativeBuildInputs = [ autoconf bison flex libtool pkg-config which ];
  buildInputs = [ libnl protobuf protobufc ];
  enableParallelBuilding = true;

  patches = [
    # To remove after bumping 3.0
    ./001-fix-bison-link-error.patch
  ];

  preBuild = ''
    makeFlagsArray+=(USER_DEFINES='-DNEWUIDMAP_PATH=${shadow}/bin/newuidmap -DNEWGIDMAP_PATH=${shadow}/bin/newgidmap')
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    install nsjail $out/bin/
    install nsjail.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "A light-weight process isolation tool, making use of Linux namespaces and seccomp-bpf syscall filters";
    homepage    = "http://nsjail.com/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ arturcygan bosu c0bw3b ];
    platforms   = platforms.linux;
  };
}
