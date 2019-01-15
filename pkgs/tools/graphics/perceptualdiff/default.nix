{ stdenv, fetchFromGitHub, cmake, freeimage }:

stdenv.mkDerivation rec {
  pname = "perceptualdiff";
  name = "${pname}-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "myint";
    repo = pname;
    rev = "v${version}";
    sha256 = "176n518xv0pczf1yyz9r5a8zw5r6sh5ym596kmvw30qznp8n4a8j";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ freeimage ];

  meta = with stdenv.lib; {
    description = "A program that compares two images using a perceptually based image metric";
    homepage = "https://github.com/myint/perceptualdiff";
    license = licenses.gpl2;
    maintainers = with maintainers; [ uri-canva ];
    platforms = platforms.x86;
  };
}
