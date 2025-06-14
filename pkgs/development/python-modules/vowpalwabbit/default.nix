{
  stdenv,
  lib,
  fetchPypi,
  buildPythonPackage,
  cmake,
  python,
  boost-python,
  zlib,
  ncurses,
  distutils,
  docutils,
  pygments,
  numpy,
  scipy,
  scikit-learn,
  spdlog,
  fmt,
  rapidjson,
}:

buildPythonPackage rec {
  pname = "vowpalwabbit";
  version = "9.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Yyqm3MlW6UL+bCufFfzWg9mBBQNhLxR+g++ZrQ6qM/E=";
  };

  patches = [ ./fix-supplied-rapidjson.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost-python
    distutils
    docutils
    ncurses
    pygments
    zlib.dev
    spdlog
    fmt
    rapidjson
  ];

  # cmakeFlags are passed through setup.py, as that is the one invoking CMake
  # instead of the derivation's builder.
  setupPyGlobalFlags =
    let
      cmake-options = lib.concatStringsSep ";" [
        "-DFMT_SYS_DEP:BOOL=ON"
        "-DRAPIDJSON_SYS_DEP:BOOL=ON"
        "-DSPDLOG_SYS_DEP:BOOL=ON"
        "-DVW_BOOST_MATH_SYS_DEP:BOOL=ON"
        "-DVW_ZLIB_SYS_DEP:BOOL=ON"
      ];
    in
    [ "--cmake-options=\"${cmake-options}\"" ];

  propagatedBuildInputs = [
    numpy
    scikit-learn
    scipy
  ];

  # Python build script uses CMake, but we don't want CMake to do the
  # configuration.
  dontUseCmakeConfigure = true;

  # Python ctypes.find_library uses DYLD_LIBRARY_PATH.
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${lib.getLib boost-python}/lib"
  '';

  checkPhase = ''
    # check-manifest requires a git clone, not a tarball
    # check-manifest --ignore "Makefile,PACKAGE.rst,*.cc,tox.ini,tests*,examples*,src*"
    ${python.interpreter} setup.py check -ms
  '';

  meta = with lib; {
    description = "Vowpal Wabbit is a fast machine learning library for online learning, and this is the python wrapper for the project";
    homepage = "https://vowpalwabbit.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    # Test again when new version is released
    broken = stdenv.hostPlatform.isLinux;
  };
}
