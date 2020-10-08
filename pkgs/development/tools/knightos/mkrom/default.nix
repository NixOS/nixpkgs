{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  pname = "mkrom";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "mkrom";
    rev = version;
    sha256 = "1nx3787gvs04xdvvamzkjkn9nmy2w70ja8dnh4szk420mvpc85na";
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
