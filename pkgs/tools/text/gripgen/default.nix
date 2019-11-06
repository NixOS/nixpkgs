{ boost, catch2, cmake, fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  pname = "gripgen";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "sc0ty";
    repo = "grip";
    rev = "v${version}";
    sha256 = "0bkqarylgzhis6fpj48qbifcd6a26cgnq8784hgnm707rq9kb0rx";
  };

  buildInputs = [ boost catch2 ];
  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/sc0ty/grip/";
    description = "Indexed grep - fast search (grep like) in huge stack of files.";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
