{ cmake, fetchFromGitHub, opencv3, stdenv, ocl-icd, opencl-headers
, cudaSupport ? false, cudatoolkit ? null
}:

stdenv.mkDerivation rec {
  pname = "waifu2x-converter-cpp";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "DeadSix27";
    repo = pname;
    rev = "v${version}";
    sha256 = "04r0xyjknvcwk70ilj1p3qwlcz3i6sqgcp0qbc9qwxnsgrrgz09w";
  };

  patchPhase = ''
    # https://github.com/DeadSix27/waifu2x-converter-cpp/issues/123
    sed -i 's:{"PNG",  false},:{"PNG",  true},:' src/main.cpp
  '';

  buildInputs = [
    opencv3 opencl-headers ocl-icd
  ] ++ stdenv.lib.optional cudaSupport cudatoolkit;

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Improved fork of Waifu2X C++ using OpenCL and OpenCV";
    homepage = "https://github.com/DeadSix27/waifu2x-converter-cpp";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.xzfc ];
    platforms = stdenv.lib.platforms.linux;
  };
}
