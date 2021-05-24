{ fetchFromGitHub, lib, stdenv, cmake }:

stdenv.mkDerivation rec {
  pname = "scas";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "scas";
    rev = version;
    sha256 = "sha256-JGQE+orVDKKJsTt8sIjPX+3yhpZkujISroQ6g19+MzU=";
  };

  cmakeFlags = [ "-DSCAS_LIBRARY=1" ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage    = "https://knightos.org/";
    description = "Assembler and linker for the Z80";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.all;
  };
}
