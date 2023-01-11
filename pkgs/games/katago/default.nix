{ stdenv
, boost
, cmake
, cudaPackages
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
, backend ? "opencl"
, enableBigBoards ? false
, enableContrib ? false
, enableTcmalloc ? true
}:

assert lib.assertOneOf "backend" backend [ "opencl" "cuda" "tensorrt" "eigen" ];

# N.b. older versions of cuda toolkit (e.g. 10) do not support newer versions
# of gcc.  If you need to use cuda10, please override stdenv with gcc8Stdenv
stdenv.mkDerivation rec {
  pname = "katago";
  version = "1.12.4";
  githash = "75280bf26582090dd4985dca62bc7124116c856d";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    sha256 = "sha256-1rznAxEFJ/Ah5/WiSwc+rtITOUOPYOua5BLKeqHOBr0=";
  };

  fakegit = writeShellScriptBin "git" "echo ${githash}";

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libzip
    boost
  ] ++ lib.optionals (backend == "eigen") [
    eigen
  ] ++ lib.optionals (backend == "cuda") [
    cudaPackages.cudnn
    cudaPackages.cudatoolkit
    mesa.drivers
  ] ++ lib.optionals (backend == "tensorrt") [
      cudaPackages.cudatoolkit
      cudaPackages.tensorrt
      mesa.drivers
  ] ++ lib.optionals (backend == "opencl") [
    opencl-headers
    ocl-icd
  ] ++ lib.optionals enableContrib [
    openssl
  ] ++ lib.optionals enableTcmalloc [
    gperftools
  ];

  cmakeFlags = [
    "-DNO_GIT_REVISION=ON"
  ] ++ lib.optionals enableAVX2 [
    "-DUSE_AVX2=ON"
  ] ++ lib.optionals (backend == "eigen") [
    "-DUSE_BACKEND=EIGEN"
  ] ++ lib.optionals (backend == "cuda") [
    "-DUSE_BACKEND=CUDA"
  ] ++ lib.optionals (backend == "tensorrt") [
    "-DUSE_BACKEND=TENSORRT"
  ] ++ lib.optionals (backend == "opencl") [
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
  '' + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
    export CUDA_PATH="${cudaPackages.cudatoolkit}"
    export EXTRA_LDFLAGS="-L/run/opengl-driver/lib"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin; cp katago $out/bin;
  '' + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
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
