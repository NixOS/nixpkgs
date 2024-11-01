{ lib, stdenv, fetchFromGitHub, cmake, asciidoc, libxslt }:


stdenv.mkDerivation rec {
  pname = "patchrom";

  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "patchrom";
    rev = version;
    sha256 = "0yc4q7n3k7k6rx3cxq5ddd5r0la8gw1287a74kql6gwkxjq0jmcv";
  };

  strictDeps = true;

  nativeBuildInputs = [ asciidoc cmake libxslt.bin ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage    = "https://knightos.org/";
    description = "Patches jumptables into TI calculator ROM files and generates an include file";
    mainProgram = "patchrom";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms   = platforms.unix;
  };
}
