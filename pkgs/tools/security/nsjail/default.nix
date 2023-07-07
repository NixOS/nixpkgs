{ lib, stdenv, fetchFromGitHub, autoconf, bison, flex, libtool, pkg-config, which
, libnl, protobuf, protobufc, shadow, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "nsjail";
  version = "3.3";

  src = fetchFromGitHub {
    owner           = "google";
    repo            = "nsjail";
    rev             = version;
    fetchSubmodules = true;
    hash            = "sha256-L5x3rUDd1nXxDjoP/ZErQa02w2MJSkMBlgu00cy1D3M=";
  };

  nativeBuildInputs = [ autoconf bison flex installShellFiles libtool pkg-config which ];
  buildInputs = [ libnl protobuf protobufc ];
  enableParallelBuilding = true;

  preBuild = ''
    makeFlagsArray+=(USER_DEFINES='-DNEWUIDMAP_PATH=${shadow}/bin/newuidmap -DNEWGIDMAP_PATH=${shadow}/bin/newgidmap')
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 nsjail "$out/bin/nsjail"
    installManPage nsjail.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "A light-weight process isolation tool, making use of Linux namespaces and seccomp-bpf syscall filters";
    homepage    = "https://nsjail.dev/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ arturcygan bosu c0bw3b ];
    platforms   = platforms.linux;
  };
}
