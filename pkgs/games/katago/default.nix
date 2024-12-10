{
  stdenv,
  boost,
  cmake,
  config,
  cudaPackages,
  eigen,
  fetchFromGitHub,
  gperftools,
  lib,
  libzip,
  makeWrapper,
  mesa,
  ocl-icd,
  opencl-headers,
  openssl,
  writeShellScriptBin,
  enableAVX2 ? stdenv.hostPlatform.avx2Support,
  backend ? if config.cudaSupport then "cuda" else "opencl",
  enableBigBoards ? false,
  enableContrib ? false,
  enableTcmalloc ? true,
  enableTrtPlanCache ? false,
}:

assert lib.assertOneOf "backend" backend [
  "opencl"
  "cuda"
  "tensorrt"
  "eigen"
];

# N.b. older versions of cuda toolkit (e.g. 10) do not support newer versions
# of gcc.  If you need to use cuda10, please override stdenv with gcc8Stdenv
stdenv.mkDerivation rec {
  pname = "katago";
  version = "1.14.1";
  githash = "f2dc582f98a79fefeb11b2c37de7db0905318f4f";

  src = fetchFromGitHub {
    owner = "lightvector";
    repo = "katago";
    rev = "v${version}";
    hash = "sha256-ZdvHvrtSLwQ5vFMzLdJSJEiGcSent9iskPgpbL1TfhI=";
  };

  fakegit = writeShellScriptBin "git" "echo ${githash}";

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs =
    [
      libzip
      boost
    ]
    ++ lib.optionals (backend == "eigen") [
      eigen
    ]
    ++ lib.optionals (backend == "cuda") [
      cudaPackages.cudnn
      cudaPackages.cudatoolkit
      mesa.drivers
    ]
    ++ lib.optionals (backend == "tensorrt") [
      cudaPackages.cudatoolkit
      cudaPackages.tensorrt
      mesa.drivers
    ]
    ++ lib.optionals (backend == "opencl") [
      opencl-headers
      ocl-icd
    ]
    ++ lib.optionals enableContrib [
      openssl
    ]
    ++ lib.optionals enableTcmalloc [
      gperftools
    ];

  cmakeFlags =
    [
      (lib.cmakeFeature "USE_BACKEND" (lib.toUpper backend))
      (lib.cmakeBool "USE_AVX2" enableAVX2)
      (lib.cmakeBool "USE_TCMALLOC" enableTcmalloc)
      (lib.cmakeBool "USE_BIGGER_BOARDS_EXPENSIVE" enableBigBoards)
      (lib.cmakeBool "USE_CACHE_TENSORRT_PLAN" enableTrtPlanCache)
      (lib.cmakeBool "NO_GIT_REVISION" (!enableContrib))
    ]
    ++ lib.optionals enableContrib [
      (lib.cmakeBool "BUILD_DISTRIBUTED" true)
      (lib.cmakeFeature "GIT_EXECUTABLE" "${fakegit}/bin/git")
    ];

  preConfigure =
    ''
      cd cpp/
    ''
    + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
      export CUDA_PATH="${cudaPackages.cudatoolkit}"
      export EXTRA_LDFLAGS="-L/run/opengl-driver/lib"
    '';

  installPhase =
    ''
      runHook preInstall
      mkdir -p $out/bin; cp katago $out/bin;
    ''
    + lib.optionalString (backend == "cuda" || backend == "tensorrt") ''
      wrapProgram $out/bin/katago \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
    ''
    + ''
      runHook postInstall
    '';

  meta = with lib; {
    description = "Go engine modeled after AlphaGo Zero";
    mainProgram = "katago";
    homepage = "https://github.com/lightvector/katago";
    license = licenses.mit;
    maintainers = [ maintainers.omnipotententity ];
    platforms = [ "x86_64-linux" ];
  };
}
