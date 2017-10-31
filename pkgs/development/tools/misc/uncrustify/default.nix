{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.64";

  src = fetchFromGitHub {
    owner = product;
    repo = product;
    rev = name;
    sha256 = "0gvgv44aqrh7cmj4ji8dpbhp47cklvajlc3s9d9z24x96dhp2v97";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = http://uncrustify.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
