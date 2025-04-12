{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  git,
  zlib,
  sparsehash,
}:

stdenv.mkDerivation rec {
  pname = "afsctool";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "RJVB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cZ0P9cygj+5GgkDRpQk7P9z8zh087fpVfrYXMRRVUAI=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    git
  ];
  buildInputs = [
    zlib
    sparsehash
  ];

  meta = with lib; {
    description = "Utility that allows end-users to leverage HFS+/APFS compression";
    license = licenses.unfree;
    maintainers = [ maintainers.viraptor ];
    platforms = platforms.darwin;
    homepage = "https://github.com/RJVB/afsctool";
  };
}
