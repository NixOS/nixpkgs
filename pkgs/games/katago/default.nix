{ stdenv
, gcc8Stdenv
, lib
, libzip
, boost
, cmake
, makeWrapper
, fetchFromGitHub
, fetchpatch
, cudnn ? null
, cudatoolkit ? null
, libGL_driver ? null
, opencl-headers ? null
, ocl-icd ? null
, gperftools ? null
, eigen ? null
, gpuEnabled ? true
, useAVX2 ? false
, cudaSupport ? false
, useTcmalloc ? true}:

assert !gpuEnabled -> (
  eigen != null &&
  !cudaSupport);

assert cudaSupport -> (
  libGL_driver != null &&
  cudatoolkit != null &&
  cudnn != null);

assert !cudaSupport -> (
  !gpuEnabled || (
    opencl-headers != null &&
    ocl-icd != null));

assert useTcmalloc -> (
  gperftools != null);

let
  env = if cudaSupport
    then gcc8Stdenv
    else stdenv;

in env.mkDerivation rec {
  pname = "katago";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "1r84ws2rj7j8085v1cqffy9rg65rzrhk6z8jbxivqxsmsgs2zs48";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libzip
    boost
  ] ++ lib.optionals (!gpuEnabled) [
    eigen
  ] ++ lib.optionals (gpuEnabled && cudaSupport) [
    cudnn
    libGL_driver
  ] ++ lib.optionals (gpuEnabled && !cudaSupport) [
    opencl-headers
    ocl-icd
  ] ++ lib.optionals useTcmalloc [
    gperftools
  ];

  cmakeFlags = [
    "-DNO_GIT_REVISION=ON"
  ] ++ lib.optionals (!gpuEnabled) [
    "-DUSE_BACKEND=EIGEN"
  ] ++ lib.optionals useAVX2 [
    "-DUSE_AVX2=ON"
  ] ++ lib.optionals (gpuEnabled && cudaSupport) [
    "-DUSE_BACKEND=CUDA"
  ] ++ lib.optionals (gpuEnabled && !cudaSupport) [
    "-DUSE_BACKEND=OPENCL"
  ] ++ lib.optionals useTcmalloc [
    "-DUSE_TCMALLOC=ON"
  ];

  preConfigure = ''
    cd cpp/
  '' + lib.optionalString cudaSupport ''
    export CUDA_PATH="${cudatoolkit}"
    export EXTRA_LDFLAGS="-L/run/opengl-driver/lib"
  '';

  installPhase = ''
    mkdir -p $out/bin; cp katago $out/bin;
  '' + lib.optionalString cudaSupport ''
    wrapProgram $out/bin/katago \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage    = "https://github.com/lightvector/katago";
    license     = licenses.mit;
    maintainers = [ maintainers.omnipotententity ];
    platforms   = [ "x86_64-linux" ];
  };
}
