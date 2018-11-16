{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.67";

  src = fetchFromGitHub {
    owner = product;
    repo = product;
    rev = name;
    sha256 = "0hf8c93aj1hjg6cc77x6p7nf7ddp8mn4b6a9gpcrvmx8w81afpd3";
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
