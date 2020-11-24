{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  pname = "mkrom";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "mkrom";
    rev = version;
    sha256 = "0xgvanya40mdwy35j94j61hsp80dm5b440iphmr5ng3kjgchvpx2";
  };

  nativeBuildInputs = [
    asciidoc
    cmake
  ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage    = "https://knightos.org/";
    description = "Packages KnightOS distribution files into a ROM";
    license     = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
