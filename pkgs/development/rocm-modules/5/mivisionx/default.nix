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
  miopengemm,
  miopen,
  migraphx,
  clang,
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

  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "MIVisionX";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-jmOgwESNALQt7ctmUY9JHgKq47tCwsW1ybynkX9236U=";
  };

  patches = [
    ../../6/mivisionx/0001-set-__STDC_CONSTANT_MACROS-to-make-rocAL-compile.patch
  ];

  nativeBuildInputs =
    [
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
    miopengemm
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

  cmakeFlags =
    [
      "-DROCM_PATH=${clr}"
      "-DAMDRPP_PATH=${rpp}"
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
    export CXXFLAGS+="--rocm-path=${clr} --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode"
    patchShebangs rocAL/rocAL_pybind/examples

    # Properly find miopengemm and miopen
    substituteInPlace amd_openvx_extensions/CMakeLists.txt \
      --replace "miopengemm PATHS \''${ROCM_PATH} QUIET" "miopengemm PATHS ${miopengemm} QUIET" \
      --replace "miopen     PATHS \''${ROCM_PATH} QUIET" "miopen PATHS ${miopen} QUIET" \
      --replace "\''${ROCM_PATH}/include/miopen/config.h" "${miopen}/include/miopen/config.h"

    # Properly find turbojpeg
    substituteInPlace amd_openvx/cmake/FindTurboJpeg.cmake \
      --replace "\''${TURBO_JPEG_PATH}/include" "${libjpeg_turbo.dev}/include" \
      --replace "\''${TURBO_JPEG_PATH}/lib" "${libjpeg_turbo.out}/lib"

    # Fix bad paths
    substituteInPlace rocAL/rocAL/rocAL_hip/CMakeLists.txt amd_openvx_extensions/amd_nn/nn_hip/CMakeLists.txt amd_openvx/openvx/hipvx/CMakeLists.txt \
      --replace "COMPILER_FOR_HIP \''${ROCM_PATH}/llvm/bin/clang++" "COMPILER_FOR_HIP ${clang}/bin/clang++"
  '';

  postBuild = lib.optionalString buildDocs ''
    python3 -m sphinx -T -E -b html -d _build/doctrees -D language=en ../docs _build/html
  '';

  postInstall = lib.optionalString (!useOpenCL && !useCPU) ''
    patchelf $out/lib/rocal_pybind*.so --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE"
    chmod +x $out/lib/rocal_pybind*.so
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Set of comprehensive computer vision and machine intelligence libraries, utilities, and applications";
    homepage = "https://github.com/ROCm/MIVisionX";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "6.0.0";
  };
})
