{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, capstone, bison, flex }:

mkDerivation rec {
  pname = "boomerang";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "BoomerangDecompiler";
    repo = pname;
    rev = "v${version}";
    sha256 = "046ba4km8c31kbnllx05nbqhjmk7bpi56d3n8md8bsr98nj21a2j";
  };

  nativeBuildInputs = [ cmake bison flex ];
  buildInputs = [ qtbase capstone ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://github.com/BoomerangDecompiler/boomerang;
    license = licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
    maintainers = with maintainers; [ dtzWill ];
  };
}
