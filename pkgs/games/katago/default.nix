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
, mesa ? null
, opencl-headers ? null
, ocl-icd ? null
, gperftools ? null
, eigen ? null
, enableAVX2 ? stdenv.hostPlatform.avx2Support
, enableBigBoards ? false
, enableCuda ? false
, enableGPU ? true
, enableTcmalloc ? true
}:

assert !enableGPU -> (
  eigen != null &&
  !enableCuda);

assert enableCuda -> (
  mesa != null &&
  cudatoolkit != null &&
  cudnn != null);

assert !enableCuda -> (
  !enableGPU || (
    opencl-headers != null &&
    ocl-icd != null));

assert enableTcmalloc -> (
  gperftools != null);

let
  env = if enableCuda
    then gcc8Stdenv
    else stdenv;

in env.mkDerivation rec {
  pname = "katago";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "030ff9prnvpadgcb4x4hx6b6ggg10bwqcj8vd8nwrdz9sjq67yf7";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libzip
    boost
  ] ++ lib.optionals (!enableGPU) [
    eigen
  ] ++ lib.optionals (enableGPU && enableCuda) [
    cudnn
    mesa.drivers
  ] ++ lib.optionals (enableGPU && !enableCuda) [
    opencl-headers
    ocl-icd
  ] ++ lib.optionals enableTcmalloc [
    gperftools
  ];

  cmakeFlags = [
    "-DNO_GIT_REVISION=ON"
  ] ++ lib.optionals (!enableGPU) [
    "-DUSE_BACKEND=EIGEN"
  ] ++ lib.optionals enableAVX2 [
    "-DUSE_AVX2=ON"
  ] ++ lib.optionals (enableGPU && enableCuda) [
    "-DUSE_BACKEND=CUDA"
  ] ++ lib.optionals (enableGPU && !enableCuda) [
    "-DUSE_BACKEND=OPENCL"
  ] ++ lib.optionals enableTcmalloc [
    "-DUSE_TCMALLOC=ON"
  ] ++ lib.optionals enableBigBoards [
    "-DUSE_BIGGER_BOARDS_EXPENSIVE=ON"
  ];

  preConfigure = ''
    cd cpp/
  '' + lib.optionalString enableCuda ''
    export CUDA_PATH="${cudatoolkit}"
    export EXTRA_LDFLAGS="-L/run/opengl-driver/lib"
  '';

  installPhase = ''
    mkdir -p $out/bin; cp katago $out/bin;
  '' + lib.optionalString enableCuda ''
    wrapProgram $out/bin/katago \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '';

  meta = with stdenv.lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage    = "https://github.com/lightvector/katago";
    license     = licenses.mit;
    maintainers = [ maintainers.omnipotententity ];
    platforms   = [ "x86_64-linux" ];
  };
}
