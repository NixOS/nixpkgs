{ stdenv, fetchFromGitHub, cmake, qtbase, capstone, bison, flex }:

stdenv.mkDerivation rec {
  pname = "boomerang";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "BoomerangDecompiler";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1q8qg506c39fidihqs8rbmqlr7bgkayyp5sscszgahs34cyvqic7";
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
