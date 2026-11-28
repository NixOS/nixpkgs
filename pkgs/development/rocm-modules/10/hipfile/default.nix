{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  rocm-runtime,
  rocprofiler-register,
  util-linux,
  gpuTargets ? (clr.localGpuTargets or clr.gpuTargets),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hipfile${clr.gpuArchSuffix}";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    tag = "therock-${finalAttrs.version}";
    sparseCheckout = [ "projects/hipfile" ];
    hash = "sha256-huhoP2J2qw/y6xdhlcLF3kH7CO2cjL5FEJXAmVucANY=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hipfile";

  # The unwrapped clang++ ignores NIX_CFLAGS_COMPILE, and hipFile links
  # libmount with a bare find_library and no include directory.
  env.CXXFLAGS = "-isystem ${lib.getDev util-linux}/include";

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs = [
    clr
    rocm-runtime
    rocprofiler-register
    # libmount, for mount-point detection
    util-linux
  ];

  cmakeFlags = [
    # Without ROCM_PATH, the build reads /opt/rocm/core-10.1/.info/version.
    (lib.cmakeFeature "ROCM_PATH" "${clr}")
    (lib.cmakeFeature "ROCM_VERSION" "10.1.0")
    (lib.cmakeFeature "CMAKE_HIP_COMPILER" "amdclang++")
    (lib.cmakeFeature "CMAKE_HIP_COMPILER_ROCM_ROOT" "${clr}")
    # backend/memcpy-kernel.hip is device code.
    (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" (lib.concatStringsSep ";" gpuTargets))
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "AIS_INSTALL_EXAMPLES" false)
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ];

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "Direct-to-GPU file I/O for ROCm, the counterpart of cuFile";
    homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/hipfile";
    license = lib.licenses.mit;
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
