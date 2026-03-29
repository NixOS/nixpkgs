{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  cmake,
  writeText,
}:

# rocm-core is used by most distros for a few purposes:
# - meta package that all rocm packages depend so `apt-get remove rocm-core` removes all rocm packages
# - provide overall ROCM_PATH
# - provide rocm version info and path to rocm version headers
# only the last usage makes sense in nixpkgs
let
  padIfSingle = s: if lib.stringLength s == 1 then "0${s}" else s;
  source = rec {
    repo = "rocm-systems";
    version = rocmVersion;
    sourceSubdir = "projects/rocm-core";
    hash = "sha256-Y3WuDwruD5zKN2epwfUCZAGq5vgxCT27awJN8JxmOsY=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-core";
  inherit (source) version src sourceRoot;

  patches = [
    ./env-rocm-path.patch
  ];

  nativeBuildInputs = [ cmake ];
  env = {
    ROCM_LIBPATCH_VERSION = "${lib.versions.major finalAttrs.version}${padIfSingle (lib.versions.minor finalAttrs.version)}${padIfSingle (lib.versions.patch finalAttrs.version)}";
    BUILD_ID = "nixpkgs-${finalAttrs.env.ROCM_LIBPATCH_VERSION}";
    ROCM_BUILD_ID = "${finalAttrs.env.BUILD_ID}";
  };
  cmakeFlags = [
    "-DROCM_LIBPATCH_VERSION=${finalAttrs.env.ROCM_LIBPATCH_VERSION}"
    "-DROCM_VERSION=${finalAttrs.version}"
    "-DBUILD_ID=${finalAttrs.env.BUILD_ID}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
  ];

  setupHook = writeText "setupHook.sh" ''
    export ROCM_VERSION="${finalAttrs.version}"
    export ROCM_LIBPATCH_VERSION="${finalAttrs.env.ROCM_LIBPATCH_VERSION}"
    export ROCM_BUILD_ID="${finalAttrs.env.ROCM_BUILD_ID}"
  '';

  doInstallCheck = true;
  preInstallCheck =
    # Test that the CMake config file can be included and sets expected vars
    ''
      mkdir test_project
      pushd test_project

      echo '
        cmake_minimum_required(VERSION 3.16)
        project(test_rocm_core)
        find_package(rocm-core REQUIRED)
        if(NOT DEFINED ROCM_CORE_INCLUDE_DIR)
          message(FATAL_ERROR "ROCM_CORE_INCLUDE_DIR not set")
        endif()
        message(STATUS "Found ROCM_CORE_INCLUDE_DIR: ''${ROCM_CORE_INCLUDE_DIR}")
        message(STATUS "Found ROCM_PATH: ''${ROCM_PATH}")
      ' > CMakeLists.txt

      CMAKE_PREFIX_PATH="$out" cmake .
      popd

      . $out/nix-support/setup-hook
      env | grep '^ROCM'
    '';

  passthru.ROCM_LIBPATCH_VERSION = finalAttrs.env.ROCM_LIBPATCH_VERSION;
  passthru.updateScript = [ ../update-rocm-monorepos.sh ];

  meta = {
    inherit (source) homepage;
    description = "Utility for getting the ROCm release version";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
