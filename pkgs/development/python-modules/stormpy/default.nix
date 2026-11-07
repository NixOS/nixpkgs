{
  lib,
  buildPythonPackage,
  python,
  stormchecker,
  carl-storm,
  carl-parser,
  storm-eigen,
  fetchFromGitHub,
  cmake,
  pybind11,
  boost,
  z3,
  glpk,
  xercesc,
  spot-automata,
  setuptools,
  scikit-build,
  scikit-build-core,
  ninja,
  deprecated,
}:

let
  finalAttrs = {
    pname = "stormpy";
    version = "1.10.0-unstable-2025-07-14";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "moves-rwth";
      repo = "stormpy";
      rev = "7e3984fcb2d4ea9f2d891f5fad7cfc15c01fda92";
      hash = "sha256-WaPtePdoOB/KScwrK/GNMcErv5YOcVJZQ8vBSaULysk=";
    };

    nativeBuildInputs = [
      setuptools
      cmake
      ninja
    ];

    buildInputs = [
      stormchecker
      carl-storm
      carl-parser
      pybind11
      boost
      z3
      glpk
      xercesc
      spot-automata
      storm-eigen
      scikit-build-core
    ];

    propagatedBuildInputs = [
      stormchecker
      deprecated
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt\
        --replace-warn "include(resources/include_pybind11.cmake)" "find_package(pybind11 REQUIRED)" \
    '';

    postConfigure = "cd ..";

    cmakeFlags = [
      #"-DSTORM_DIR_HINT=${stormchecker.out}/lib/CMake/storm"
      "-DCARL_DIR_HINT=${carl-storm.out}/lib/cmake"
      "-Dcarl_DIR=${carl-storm.out}/lib/cmake"
      "-DZ3_DIR=${z3.dev}/lib/cmake/z3"
      "-DCARLSPARSER_DIR_HINT=${carl-parser.out}/lib/cmake/carlparser"
      "-Dpybind11_DIR=${pybind11.out}/share/cmake/pybind11"
      "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${placeholder "out"}/${python.sitePackages}/stormpy"
    ];

    env = {
      CMAKE_ARGS = lib.concatStringsSep " " [
        #"-DSTORM_DIR_HINT=${stormchecker}/lib/cmake/storm"
        "-DCARL_DIR_HINT=${carl-storm}/lib/cmake"
        "-Dcarl_DIR=${carl-storm}/lib/cmake"
        "-DZ3_DIR=${z3.dev}/lib/cmake/z3"
        "-DCARLPARSER_DIR_HINT=${carl-parser}/lib/cmake/carlparser"
        "-Dpybind11_DIR=${pybind11}/share/cmake/pybind11"
        "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${placeholder "out"}/${python.sitePackages}/stormpy"
      ];

      NIX_CFLAGS_COMPILE = "-I${storm-eigen}/include/eigen3";

    };

    meta = {
      description = "Bindings for the storm model checker";
      homepage = "https://moves-rwth.github.io/stormpy";
      license = lib.licenses.gpl3Plus;
      maintainers = [ lib.maintainers.astrobeastie ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  };
in
buildPythonPackage finalAttrs
