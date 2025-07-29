{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-device-libs,
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
  libjpeg_turbo,
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

  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "MIVisionX";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-SisCbUDCAiWQ1Ue7qrtoT6vO/1ztzqji+3cJD6MXUNw=";
  };

  patches = [
    ./0001-set-__STDC_CONSTANT_MACROS-to-make-rocAL-compile.patch
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    pkg-config
  ]
  ++ lib.optionals buildDocs [
    rocm-docs-core
    python3Packages.python
  ];

  buildInputs = [
    miopen
    migraphx
    rpp
    rocblas
    openmp
    half
    protobuf
    qtcreator
    opencv
    ffmpeg
    boost
    libjpeg_turbo
    lmdb
    rapidjson
    python3Packages.pybind11
    python3Packages.numpy
    python3Packages.torchWithRocm
  ];

  cmakeFlags = [
    "-DROCM_PATH=${clr}"
    "-DAMDRPP_PATH=${rpp}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_PREFIX_PYTHON=lib"
    "-DOpenMP_C_INCLUDE_DIR=${openmp.dev}/include"
    "-DOpenMP_CXX_INCLUDE_DIR=${openmp.dev}/include"
    "-DOpenMP_omp_LIBRARY=${openmp}/lib"
    # "-DAMD_FP16_SUPPORT=ON" `error: typedef redefinition with different types ('__half' vs 'half_float::half')`
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

  postPatch = ''
    # We need to not use hipcc and define the CXXFLAGS manually due to `undefined hidden symbol: tensorflow:: ...`
    export CXXFLAGS+=" --rocm-path=${clr} --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode"
    # Properly find miopen, fix ffmpeg version detection
    substituteInPlace amd_openvx_extensions/CMakeLists.txt \
      --replace-fail "miopen     PATHS \''${ROCM_PATH} QUIET" "miopen PATHS ${miopen} QUIET" \
      --replace-fail "\''${ROCM_PATH}/include/miopen/config.h" "${miopen}/include/miopen/config.h"

    # Properly find turbojpeg
    substituteInPlace cmake/FindTurboJpeg.cmake \
      --replace-fail "\''${TURBO_JPEG_PATH}/include" "${libjpeg_turbo.dev}/include" \
      --replace-fail "\''${TURBO_JPEG_PATH}/lib" "${libjpeg_turbo.out}/lib"
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
