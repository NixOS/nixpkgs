{ lib, stdenv, fetchFromGitHub, autoconf, bison, flex, libtool, pkg-config, which
, libnl, protobuf, protobufc, shadow, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "nsjail";
  version = "3.1";

  src = fetchFromGitHub {
    owner           = "google";
    repo            = "nsjail";
    rev             = version;
    fetchSubmodules = true;
    sha256          = "sha256-ICJpD7iCT7tLRX+52XvayOUuO1g0L0jQgk60S2zLz6c=";
  };

  nativeBuildInputs = [ autoconf bison flex libtool pkg-config which installShellFiles ];
  buildInputs = [ libnl protobuf protobufc ];
  enableParallelBuilding = true;

  preBuild = ''
    makeFlagsArray+=(USER_DEFINES='-DNEWUIDMAP_PATH=${shadow}/bin/newuidmap -DNEWGIDMAP_PATH=${shadow}/bin/newgidmap')
  '';

  installPhase = ''
    install -Dm755 nsjail "$out/bin/nsjail"
    installManPage nsjail.1
  '';

  meta = with lib; {
    description = "A light-weight process isolation tool, making use of Linux namespaces and seccomp-bpf syscall filters";
    homepage    = "http://nsjail.com/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ arturcygan bosu c0bw3b ];
    platforms   = platforms.linux;
  };
}
