{lib, stdenv, fetchurl, cmake, perl}:

stdenv.mkDerivation rec {
  pname = "halibut";
  version = "1.3";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-${version}/halibut-${version}.tar.gz";
    sha256 = "0ciikn878vivs4ayvwvr63nnhpcg12m8023xv514zxqpdxlzg85a";
  };

  nativeBuildInputs = [ cmake perl ];

  meta = with lib; {
    description = "Documentation production system for software manuals";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/halibut/";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
    mainProgram = "halibut";
  };
}
