{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "tlsh";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "tlsh";
    rev = version;
    hash = "sha256-m4DhhfIAAXSjZYTg5iQ4h9flrL6j9HGNn8AN89hQ94M=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Trend Micro Locality Sensitive Hash";
    homepage = "https://tlsh.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ snicket2100 ];
  };

}
