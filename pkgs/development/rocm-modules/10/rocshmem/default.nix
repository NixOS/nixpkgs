{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-core,
  rocm-runtime,
  clr,
  mpi,
  useMpi ? true,
  useReverseOffload ? useMpi,
  buildExamples ? false,
  gpuTargets ? (clr.localGpuTargets or [ ]),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocshmem${clr.gpuArchSuffix}";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    # rocSHMEM lives in the rocm-systems monorepo since ROCm 10
    repo = "rocm-systems";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/rocshmem"
      "shared"
    ];
    hash = "sha256-uVUHYyJbaE5vauN1mczLf7rYNxRSD93eJDIDbzbYzHs=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocshmem";

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs = [
    rocm-runtime
  ]
  ++ lib.optionals useMpi [
    mpi
  ];

  # The device bitcode command does not see the HSA headers the host target gets.
  postPatch = ''
    substituteInPlace cmake/DeviceBitcode.cmake \
      --replace-fail \
        '-Xclang -mcode-object-version=none' \
        '-Xclang -mcode-object-version=none
    -I${rocm-runtime}/include'
  '';

  cmakeFlags = [
    (lib.cmakeBool "CMAKE_POSITION_INDEPENDENT_CODE" true)
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "hipcc")
    (lib.cmakeFeature "ROCM_PATH" "${clr}")
    (lib.cmakeFeature "ROCM_VERSION" rocm-core.ROCM_LIBPATCH_VERSION)
    (lib.cmakeBool "USE_IPC" true)
    (lib.cmakeBool "USE_RO" useReverseOffload)
    (lib.cmakeBool "USE_SINGLE_NODE" (!useMpi))
    (lib.cmakeBool "USE_EXTERNAL_MPI" useMpi)
    (lib.cmakeBool "BUILD_EXAMPLES" buildExamples)
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    (lib.cmakeFeature "GPU_TARGETS" (lib.concatStringsSep ";" gpuTargets))
  ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "The ROCm OpenSHMEM (rocSHMEM) runtime";
    homepage = "https://github.com/ROCm/rocSHMEM";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
