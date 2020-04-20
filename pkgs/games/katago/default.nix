{ stdenv
, gcc8Stdenv
, lib
, libzip
, boost
, cmake
, makeWrapper
, fetchFromGitHub
, cudnn ? null
, cudatoolkit ? null
, libGL_driver ? null
, opencl-headers ? null
, ocl-icd ? null
, gperftools ? null
, cudaSupport ? false
, useTcmalloc ? true}:

assert cudaSupport -> (
  libGL_driver != null && 
  cudatoolkit != null &&
  cudnn != null);

assert !cudaSupport -> (
  opencl-headers != null &&
  ocl-icd != null);

assert useTcmalloc -> (
  gperftools != null);

let
  env = if cudaSupport 
    then gcc8Stdenv
    else stdenv;

in env.mkDerivation rec {
  pname = "katago";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "1625s3fh0xc2ldgyl6sjdjmpliyys7rzzkcys6h9x6k828g8n0lq";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libzip
    boost
  ] ++ lib.optionals cudaSupport [
    cudnn
    libGL_driver
  ] ++ lib.optionals (!cudaSupport) [
    opencl-headers
    ocl-icd
  ] ++ lib.optionals useTcmalloc [
    gperftools
  ];

  cmakeFlags = [
    "-DNO_GIT_REVISION=ON"
  ] ++ lib.optionals cudaSupport [
    "-DUSE_BACKEND=CUDA"
  ] ++ lib.optionals (!cudaSupport) [
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
