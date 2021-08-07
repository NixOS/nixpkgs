{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "rocm-cmake";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "rocm-cmake";
    rev = "rocm-${version}";
    hash = "sha256-uK060F7d7/pTCNbGqdKCzxgPrPPbGjNwuUOt176z7EM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CMake modules for common build tasks for the ROCm stack";
    homepage = "https://github.com/RadeonOpenCompute/rocm-cmake";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
