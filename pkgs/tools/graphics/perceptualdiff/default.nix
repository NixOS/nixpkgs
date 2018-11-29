{ stdenv, fetchFromGitHub, cmake, freeimage }:

stdenv.mkDerivation rec {
  pname = "perceptualdiff";
  name = "${pname}-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "myint";
    repo = pname;
    rev = "v${version}";
    sha256 = "12sx2alidfba07v281jrvr5dxxsalp263x92lag6r9swj5nbbgn2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ freeimage ];

  meta = with stdenv.lib; {
    description = "A program that compares two images using a perceptually based image metric";
    homepage = "https://github.com/myint/perceptualdiff";
    license = licenses.gpl2;
    maintainers = with maintainers; [ uri-canva ];
    platforms = platforms.unix;
  };
}
