{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "kmsjsoncpp";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "Kurento";
    repo = "jsoncpp";
    rev = version;
    sha256 = "1jnl70kirg4yvxhiacwhhjwf534371ahskf2gf1rpvm8bq42gxia";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A C++ library for interacting with JSON - Kurento fork";
    homepage = "https://github.com/Kurento/jsoncpp";
    license = with licenses; [ mit ];
  };
}
