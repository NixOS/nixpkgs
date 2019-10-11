{ stdenv, fetchFromGitHub, cmake, qtbase, capstone, bison, flex }:

stdenv.mkDerivation rec {
  pname = "boomerang";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "BoomerangDecompiler";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "046ba4km8c31kbnllx05nbqhjmk7bpi56d3n8md8bsr98nj21a2j";
  };

  nativeBuildInputs = [ cmake bison flex ];
  buildInputs = [ qtbase capstone ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://boomerang.sourceforge.net/;
    license = licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
    maintainers = with maintainers; [ dtzWill ];
  };
}
