{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  clr,
  rocm-cmake,
  rocm-runtime,
  rocprofiler-register,
  aqlprofile,
  rocm-comgr,
  python3,
  libdrm,
  elfutils,
  sqlite,
  otf2,
  buildTests ? false,
  buildSamples ? false,
}:

# FIXME: devendor these, currently git submodules:
#   external/cereal     -> https://github.com/jrmadsen/cereal
#   external/elfio      -> https://github.com/serge1/ELFIO
#   external/filesystem -> https://github.com/gulrak/filesystem
#   external/fmt        -> https://github.com/fmtlib/fmt
#   external/glog       -> https://github.com/google/glog
#   external/googletest -> https://github.com/google/googletest
#   external/gotcha     -> https://github.com/jrmadsen/GOTCHA
#   external/json       -> https://github.com/nlohmann/json
#   external/perfetto   -> https://github.com/google/perfetto
#   external/ptl        -> https://github.com/jrmadsen/PTL
#   external/pybind11   -> https://github.com/pybind/pybind11
#   external/sqlite     -> https://github.com/sqlite/sqlite
#   external/yaml-cpp   -> https://github.com/jbeder/yaml-cpp

# rocprofiler-sdk is the home of rocprofv3
stdenv.mkDerivation (finalAttrs: {
  pname = "rocprofiler-sdk";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocm-systems";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-+kj4I7d5i1m+RnkG1GcoBTvWli0IdndAyUXwAiu8tPw=";
    fetchSubmodules = true;
    sparseCheckout = [
      "projects/rocprofiler-sdk"
    ];
  };

  sourceRoot = "${finalAttrs.src.name}/projects/rocprofiler-sdk";

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    clr
    python3
  ];

  buildInputs = [
    clr
    rocm-cmake
    rocm-runtime
    rocprofiler-register
    aqlprofile
    rocm-comgr
    libdrm
    elfutils
    sqlite
    otf2
  ];

  # FIXME: upstream these
  postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace-fail "find_package(Git)" "# find_package(Git)"
        # Missing <cstdint> in vendored deps
        sed -i '1i #include <cstdint>' external/yaml-cpp/src/emitterutils.cpp
        sed -i '1i #include <cstdint>' external/elfio/elfio/elf_types.hpp
        # Python bindings use object files from rocprofiler-sdk-object-library which
        # transitively include amd_comgr headers, but don't link the comgr interface target
        substituteInPlace source/lib/python/utilities.cmake \
          --replace-fail \
            "rocprofiler-sdk::rocprofiler-sdk-rocpd-library)" \
            "rocprofiler-sdk::rocprofiler-sdk-rocpd-library rocprofiler-sdk::rocprofiler-sdk-amd-comgr)"
        # Use system otf2 instead of vendored ExternalProject build
        substituteInPlace external/CMakeLists.txt \
          --replace-fail "add_subdirectory(otf2)" "
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(OTF2 REQUIRED IMPORTED_TARGET otf2)
    add_library(otf2 INTERFACE)
    add_library(otf2::otf2 ALIAS otf2)
    target_link_libraries(otf2 INTERFACE PkgConfig::OTF2)
    "
  '';

  cmakeFlags = [
    (lib.cmakeBool "ROCPROFILER_BUILD_TESTS" buildTests)
    (lib.cmakeBool "ROCPROFILER_BUILD_SAMPLES" buildSamples)
    (lib.cmakeBool "ROCPROFILER_BUILD_BENCHMARK" false)
    (lib.cmakeBool "ROCPROFILER_BUILD_WERROR" false)
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  env.ROCM_PATH = "${clr}";

  meta = {
    description = "ROCm GPU performance analysis SDK";
    homepage = "https://github.com/ROCm/rocprofiler-sdk";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
