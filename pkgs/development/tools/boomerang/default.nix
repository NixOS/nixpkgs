{ mkDerivation, lib, fetchFromGitHub, cmake, qtbase, capstone, bison, flex }:

mkDerivation rec {
  pname = "boomerang";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "BoomerangDecompiler";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xncdp0z8ry4lkzmvbj5d7hlzikivghpwicgywlv47spgh8ny0ix";
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
