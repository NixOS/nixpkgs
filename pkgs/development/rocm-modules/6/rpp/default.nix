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
  useOpenCL ? false,
  useCPU ? false,
  gpuTargets ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname =
    "rpp-"
    + (
      if (!useOpenCL && !useCPU) then
        "hip"
      else if (!useOpenCL && !useCPU) then
        "opencl"
      else
        "cpu"
    );

  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rpp";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-AquAVoEqlsBVxd41hG2sVo9UoSS+255eCQzIfGkC/Tk=";
  };

  nativeBuildInputs =
    [
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

  cmakeFlags =
    [
      "-DROCM_PATH=${clr}"
    ]
    ++ lib.optionals (gpuTargets != [ ]) [
      "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
    ]
    ++ lib.optionals (!useOpenCL && !useCPU) [
      "-DCMAKE_C_COMPILER=hipcc"
      "-DCMAKE_CXX_COMPILER=hipcc"
      "-DBACKEND=HIP"
    ]
    ++ lib.optionals (useOpenCL && !useCPU) [
      "-DBACKEND=OCL"
    ]
    ++ lib.optionals useCPU [
      "-DBACKEND=CPU"
    ];

  postPatch = lib.optionalString (!useOpenCL && !useCPU) ''
    # Bad path
    substituteInPlace CMakeLists.txt \
      --replace "COMPILER_FOR_HIP \''${ROCM_PATH}/llvm/bin/clang++" "COMPILER_FOR_HIP ${clr}/bin/hipcc"
  '';

  postBuild = lib.optionalString buildDocs ''
    python3 -m sphinx -T -E -b html -d _build/doctrees -D language=en ../docs _build/html
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Comprehensive high-performance computer vision library for AMD processors";
    homepage = "https://github.com/ROCm/rpp";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
