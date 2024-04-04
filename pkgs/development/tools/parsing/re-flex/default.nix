{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "re-flex";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "RE-flex";
    rev = "v${version}";
    hash = "sha256-w1aH04VGe9nPvwGdbTEsAcIPb7oC739LZjTI/1Ck7bU=";
  };

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://www.genivia.com/doc/reflex/html";
    description = "The regex-centric, fast lexical analyzer generator for C++ with full Unicode support";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ prrlvr ];
    mainProgram = "reflex";
  };
}
