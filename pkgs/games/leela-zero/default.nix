{ lib, stdenv, fetchFromGitHub, cmake, boost
, opencl-headers, ocl-icd, qtbase , zlib }:

stdenv.mkDerivation rec {
  pname = "leela-zero";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "gcp";
    repo = "leela-zero";
    rev = "v${version}";
    sha256 = "1k04ld1ysabxb8ivci3ji5by9vb3yvnflkf2fscs1x0bp7d6j101";
    fetchSubmodules = true;
  };

  buildInputs = [ boost opencl-headers ocl-icd qtbase zlib ];

  nativeBuildInputs = [ cmake ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage    = "https://github.com/gcp/leela-zero";
    license     = licenses.gpl3;
    maintainers = [ maintainers.averelld maintainers.omnipotententity ];
    platforms   = platforms.linux;
  };
}
