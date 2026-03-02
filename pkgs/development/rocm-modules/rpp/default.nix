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
  gpuTargets ? clr.localGpuTargets or [ ],
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

  version = "7.1.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rpp";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-ZlJRV57ybPsczvoWwd5vr2n7EKje0vj2GJYsvVY+qas=";
  };

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
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ]
  ++ lib.optionals (!useOpenCL && !useCPU) [
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
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "Comprehensive high-performance computer vision library for AMD processors";
    homepage = "https://github.com/ROCm/rpp";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
    broken = useOpenCL;
  };
})
