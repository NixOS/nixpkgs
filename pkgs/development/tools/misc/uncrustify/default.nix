{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.71.0";

  src = fetchFromGitHub {
    owner = product;
    repo = product;
    rev = name;
    sha256 = "1wyhkhn000yad94fnjj61h7lyvan6hig8wh7jxlnyp5wxdwki0pj";
  };

  nativeBuildInputs = [ cmake python ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = "http://uncrustify.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
