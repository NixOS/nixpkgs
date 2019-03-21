{ stdenv, fetchurl, fetchFromGitHub, cmake, boost, eigen
, opencl-headers, ocl-icd, qtbase , zlib }:

stdenv.mkDerivation rec {
  name = "leela-zero-${version}";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "gcp";
    repo = "leela-zero";
    rev = "v${version}";
    sha256 = "1px7wqvlv414gklzgrmppp8wzc2mkskinm1p75j4snbqr8qpbn5s";
    fetchSubmodules = true;
  };

  buildInputs = [ boost opencl-headers ocl-icd qtbase zlib ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage    = https://github.com/gcp/leela-zero;
    license     = licenses.gpl3;
    maintainers = [ maintainers.averelld ];
    platforms   = platforms.linux;
  };
}
