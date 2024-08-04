{
  stdenv,
  lib,
  fetchPypi,
  buildPythonPackage,
  cmake,
  python,
  zlib,
  ncurses,
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
  version = "9.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YCg2EI4rhEMwcVEzx9ES8Z3CoCddeUFVk4lZ0nuQJUc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    docutils
    ncurses
    pygments
    python.pkgs.boost
    zlib.dev
    spdlog
    fmt
    rapidjson
  ];

  # As we disable configure via cmake, pass explicit global options to enable
  # spdlog and fmt packages
  setupPyGlobalFlags = [ "--cmake-options=\"-DSPDLOG_SYS_DEP=ON;-DFMT_SYS_DEP=ON\"" ];

  propagatedBuildInputs = [
    numpy
    scikit-learn
    scipy
  ];

  # Python build script uses CMake, but we don't want CMake to do the
  # configuration.
  dontUseCmakeConfigure = true;

  # Python ctypes.find_library uses DYLD_LIBRARY_PATH.
  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${python.pkgs.boost}/lib"
  '';

  checkPhase = ''
    # check-manifest requires a git clone, not a tarball
    # check-manifest --ignore "Makefile,PACKAGE.rst,*.cc,tox.ini,tests*,examples*,src*"
    ${python.interpreter} setup.py check -ms
  '';

  meta = with lib; {
    description = "Vowpal Wabbit is a fast machine learning library for online learning, and this is the python wrapper for the project";
    homepage = "https://github.com/JohnLangford/vowpal_wabbit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    # Test again when new version is released
    broken = stdenv.isLinux;
  };
}
