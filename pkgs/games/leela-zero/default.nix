{ stdenv, fetchurl, fetchFromGitHub, cmake, boost, eigen
, opencl-headers, ocl-icd, qtbase , zlib }:

stdenv.mkDerivation rec {
  name = "leela-zero-${version}";
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage    = https://github.com/gcp/leela-zero;
    license     = licenses.gpl3;
    maintainers = [ maintainers.averelld maintainers.omnipotententity ];
    platforms   = platforms.linux;
  };
}
