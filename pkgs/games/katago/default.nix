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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "0qdc9hgbzd175b2xkjs62dy6gyybcn9lf1mifiyhjbzjpgv192h4";
  };

  # To workaround CMake 3.17.0's new buggy behavior wrt CUDA Compiler testing
  # See the following tracking issues:
  # KataGo:
  #  - Issue #225: https://github.com/lightvector/KataGo/issues/225
  #  - PR #227: https://github.com/lightvector/KataGo/pull/227
  # CMake:
  #  - Issue #20708: https://gitlab.kitware.com/cmake/cmake/-/issues/20708
  patches = [
    (fetchpatch {
      name = "227.patch";
      url = "https://patch-diff.githubusercontent.com/raw/lightvector/KataGo/pull/227.patch";
      sha256 = "03f1vmdjhb79mpj95sijcwla8acy32clrjgrn4xqw5h90zdgj511";
    })
  ];

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
