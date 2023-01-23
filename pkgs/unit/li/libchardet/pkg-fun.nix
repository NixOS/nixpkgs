{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "libchardet";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "Joungkyun";
    repo = "libchardet";
    rev = version;
    sha256 = "sha256-JhEiWM3q8X+eEBHxv8k9yYOaTGoJOzI+/iFYC0gZJJs=";
  };

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage = "ftp://ftp.oops.org/pub/oops/libchardet/index.html";
    license = licenses.mpl11;
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.unix;
  };
}
