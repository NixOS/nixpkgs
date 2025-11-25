{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  pkg-config,
  rpp,
  rocblas,
  miopen,
  migraphx,
  openmp,
  protobuf,
  qtcreator,
  opencv,
  ffmpeg,
  boost,
  half,
  lmdb,
  rapidjson,
  rocm-docs-core,
  python3Packages,
  useOpenCL ? false,
  useCPU ? false,
  buildDocs ? false, # Needs internet
  gpuTargets ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname =
    "mivisionx-"
    + (
      if (!useOpenCL && !useCPU) then
        "hip"
      else if (!useOpenCL && !useCPU) then
        "opencl"
      else
        "cpu"
    );

  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "MIVisionX";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-07MivgCYmKLnhGDjOYsFBfwIxEoQLYNoRbOo3MPpVzE=";
  };

  patches = [
    ./0001-set-__STDC_CONSTANT_MACROS-to-make-rocAL-compile.patch
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    pkg-config
  ]
  ++ lib.optionals (!useOpenCL && !useCPU) [
    clr
  ]
  ++ lib.optionals buildDocs [
    rocm-docs-core
    python3Packages.python
  ];

  buildInputs = [
    rpp
    openmp
    half
    protobuf
    qtcreator
    opencv
    ffmpeg
    boost
    lmdb
    rapidjson
    python3Packages.pybind11
    python3Packages.numpy
  ]
  ++ lib.optionals (!useOpenCL && !useCPU) [
    miopen
    rocblas
    migraphx
  ];

  cmakeFlags = [
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_PREFIX_PYTHON=lib"
    # "-DAMD_FP16_SUPPORT=ON" `error: typedef redefinition with different types ('__half' vs 'half_float::half')`
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ]
  ++ lib.optionals (!useOpenCL && !useCPU) [
    "-DROCM_PATH=${clr}"
    "-DAMDRPP_PATH=${rpp}"
    "-DBACKEND=HIP"
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
  ]
  ++ lib.optionals (useOpenCL && !useCPU) [
    "-DBACKEND=OCL"
  ]
  ++ lib.optionals useCPU [
    "-DBACKEND=CPU"
  ];

  postPatch = ''
    ${lib.optionalString (!useOpenCL && !useCPU) ''
      # Properly find miopen
      substituteInPlace amd_openvx_extensions/CMakeLists.txt \
        --replace-fail "miopen     PATHS \''${ROCM_PATH} QUIET" "miopen PATHS ${miopen} QUIET" \
        --replace-fail "\''${ROCM_PATH}/include/miopen/config.h" "${miopen}/include/miopen/config.h"
    ''}
  '';

  postBuild = lib.optionalString buildDocs ''
    python3 -m sphinx -T -E -b html -d _build/doctrees -D language=en ../docs _build/html
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Set of comprehensive computer vision and machine intelligence libraries, utilities, and applications";
    homepage = "https://github.com/ROCm/MIVisionX";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
    broken = useOpenCL;
  };
})
