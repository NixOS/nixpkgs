{ cmake, fetchFromGitHub, makeWrapper, opencv3, lib, stdenv, ocl-icd, opencl-headers
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
    ocl-icd opencv3 opencl-headers
  ] ++ lib.optional cudaSupport cudatoolkit;

  nativeBuildInputs = [ cmake makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/waifu2x-converter-cpp --prefix LD_LIBRARY_PATH : "${ocl-icd}/lib"
  '';

  meta = {
    description = "Improved fork of Waifu2X C++ using OpenCL and OpenCV";
    homepage = "https://github.com/DeadSix27/waifu2x-converter-cpp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xzfc ];
    platforms = lib.platforms.linux;
  };
}
