{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-docs-core,
  half,
  clr,
  openmp,
  boost,
  python3Packages,
  buildDocs ? false, # Needs internet
  useCPU ? false,
  gpuTargets ? clr.localGpuTargets or [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpp-${if useCPU then "cpu" else "hip"}";

  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    # rpp lives in the rocm-libraries monorepo since ROCm 10
    repo = "rocm-libraries";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [
      "projects/rpp"
      "shared"
    ];
    hash = "sha256-ZD3gzZhb1n5hSJ6nnYVksuoYEEy+wzaLbh02tMdv8dQ=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rpp";

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ]
  ++ lib.optionals buildDocs [
    rocm-docs-core
    python3Packages.python
  ];

  buildInputs = [
    half
    openmp
    boost
  ];

  cmakeFlags = [
    "-DROCM_PATH=${clr}"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DBACKEND=${if useCPU then "CPU" else "HIP"}"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ];

  # -fopenmp adds the toolchain include dir, which holds glibc's headers, as a
  # plain -I; keep it a system dir so mm_malloc.h compiles with glibc >= 2.44.
  env = lib.optionalAttrs useCPU {
    CXXFLAGS = "-isystem ${stdenv.cc}/include";
  };

  postPatch =
    # api/rppdefs.h includes <half.hpp>, so half must be a PUBLIC dependency.
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'set_target_properties(''${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)' \
          $'target_link_libraries(''${PROJECT_NAME} PUBLIC HALF::half)\nset_target_properties(''${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON)'
    ''
    + lib.optionalString (!useCPU) ''
      # Bad path
      substituteInPlace CMakeLists.txt \
        --replace "COMPILER_FOR_HIP \''${ROCM_PATH}/llvm/bin/clang++" "COMPILER_FOR_HIP ${clr}/bin/hipcc"
    '';

  postBuild = lib.optionalString buildDocs ''
    python3 -m sphinx -T -E -b html -d _build/doctrees -D language=en ../docs _build/html
  '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "Comprehensive high-performance computer vision library for AMD processors";
    homepage = "https://github.com/ROCm/rpp";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
