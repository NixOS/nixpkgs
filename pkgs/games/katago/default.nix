{ stdenv
, gcc8Stdenv
, boost
, cmake
, cudatoolkit
, cudnn
, eigen
, fetchFromGitHub
, gperftools
, lib
, libzip
, makeWrapper
, mesa
, ocl-icd
, opencl-headers
, openssl
, writeShellScriptBin
, enableAVX2 ? stdenv.hostPlatform.avx2Support
, enableBigBoards ? false
, enableCuda ? false
, enableContrib ? false
, enableGPU ? true
, enableTcmalloc ? true
}:

assert !enableGPU -> (
  !enableCuda);

let
  env = if enableCuda
    then gcc8Stdenv
    else stdenv;

in env.mkDerivation rec {
  pname = "katago";
  version = "1.8.1";
  githash = "73bc3e38b3490cbe00179c9c37f5385dfd60c6bc";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "sha256-Rj6fgj1ZQgYhz6TrZk5b8dCMsCPk5N3qN3kgqV+UEDc=";
  };

  fakegit = writeShellScriptBin "git" "echo ${githash}";

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
  ] ++ lib.optionals enableContrib [
    openssl
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
  ] ++ lib.optionals enableContrib [
    "-DBUILD_DISTRIBUTED=1"
    "-DNO_GIT_REVISION=OFF"
    "-DGIT_EXECUTABLE=${fakegit}/bin/git"
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
    runHook preInstall
    mkdir -p $out/bin; cp katago $out/bin;
  '' + lib.optionalString enableCuda ''
    wrapProgram $out/bin/katago \
      --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '' + ''
    runHook postInstall
  '';

  meta = with lib; {
    description = "Go engine modeled after AlphaGo Zero";
    homepage    = "https://github.com/lightvector/katago";
    license     = licenses.mit;
    maintainers = [ maintainers.omnipotententity ];
    platforms   = [ "x86_64-linux" ];
  };
}
