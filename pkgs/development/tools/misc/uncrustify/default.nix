{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.66";

  src = fetchFromGitHub {
    owner = product;
    repo = product;
    rev = name;
    sha256 = "156y71yf2xxskvikbn6yjfv8xgnsrrjij08irv21z0n7nx35jgmm";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = http://uncrustify.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
