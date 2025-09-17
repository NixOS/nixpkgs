{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-core";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-core";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-UDnPGvgwzwv49CzF+Kt0v95CsxS33BZeqNcKw1K6jRI=";
  };

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
  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
    page = "tags?per_page=4";
  };

  meta = with lib; {
    description = "Utility for getting the ROCm release version";
    homepage = "https://github.com/ROCm/rocm-core";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
