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
stdenv.mkDerivation (
  finalAttrs:
  let
    # TheRock tags are two-component (therock-10.1); ROCm reports X.Y.Z.
    rocmVersion = lib.versions.pad 3 finalAttrs.version;
  in
  {
    pname = "rocm-core";
    version = "10.1";

    src = fetchFromGitHub {
      owner = "ROCm";
      repo = "rocm-systems";
      tag = "therock-${finalAttrs.version}";
      sparseCheckout = [
        "projects/rocm-core"
        "shared"
      ];
      hash = "sha256-3bEmFF4jivCslDINOTA5nIu1/nreGWZuIMYMxaUgd18=";
    };
    sourceRoot = "${finalAttrs.src.name}/projects/rocm-core";

    patches = [
      ./env-rocm-path.patch
    ];

    nativeBuildInputs = [ cmake ];
    env = {
      ROCM_LIBPATCH_VERSION = "${lib.versions.major rocmVersion}${padIfSingle (lib.versions.minor rocmVersion)}${padIfSingle (lib.versions.patch rocmVersion)}";
      BUILD_ID = "nixpkgs-${finalAttrs.env.ROCM_LIBPATCH_VERSION}";
      ROCM_BUILD_ID = "${finalAttrs.env.BUILD_ID}";
    };
    cmakeFlags = [
      "-DROCM_LIBPATCH_VERSION=${finalAttrs.env.ROCM_LIBPATCH_VERSION}"
      "-DROCM_VERSION=${rocmVersion}"
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
    passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

    meta = {
      description = "Utility for getting the ROCm release version";
      homepage = "https://github.com/ROCm/rocm-systems/tree/develop/projects/rocm-core";
      license = lib.licenses.mit;
      teams = [ lib.teams.rocm ];
      platforms = lib.platforms.linux;
    };
  }
)
