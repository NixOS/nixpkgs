{ fetchFromGitHub
, lib
, stdenv
, boost
, zlib
, cmake
}:

stdenv.mkDerivation rec {
  pname = "maeparser";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "maeparser";
    rev = "v${version}";
    sha256 = "sha256-9KxCR/spIZzePjmZe8qihIi1hEhPvxg/9dAlYmHxZPs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib ];

  meta = with lib; {
    homepage = "https://github.com/schrodinger/maeparser";
    description = "Maestro file parser";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
