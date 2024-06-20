{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "re-flex";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "RE-flex";
    rev = "v${version}";
    hash = "sha256-tWV7HnIeTao3IbT2xxsu+//4aLQLKP/+ySqrvzU139c=";
  };

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://www.genivia.com/doc/reflex/html";
    description = "Regex-centric, fast lexical analyzer generator for C++ with full Unicode support";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ prrlvr ];
    mainProgram = "reflex";
  };
}
