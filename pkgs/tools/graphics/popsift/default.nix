{ stdenv
, fetchFromGitHub
, cmake
, boost
, cudatoolkit
, libdevil
}:

stdenv.mkDerivation rec {
  pname = "popsift";
  version = "0.9.x";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = pname;
    rev = "4c22d41579c17d7326938929c00c54cfa01a4592";
    sha256 = "X9yLCMWKXRYdxzV1dsgswjgfaB+29judbIAlDYX+G3c=";
  };
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    boost
    # Needed, POPSIFT is Unfree
    cudatoolkit
    libdevil
  ];
}
