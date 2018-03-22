{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.66.1";

  src = fetchFromGitHub {
    owner = product;
    repo = product;
    rev = name;
    sha256 = "1y69b0g07ksynf1fwfh5qqwmscxfbvs1yi3n3lbdd4vplb9zakyx";
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
