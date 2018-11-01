{ stdenv, lib, buildPythonPackage, fetchPypi, python, boost, zlib, clang
, ncurses, pytest, docutils, pygments, numpy, scipy, scikitlearn }:

buildPythonPackage rec {
  pname = "vowpalwabbit";
  version = "8.5.0";

  src = fetchPypi{
    inherit pname version;
    sha256 = "0b517371fc64f1c728a0af42a31fa93def27306e9b4d25d6e5fd01bcff1b7304";
  };

  # Should be fixed in next Python release after 8.5.0:
  # https://github.com/JohnLangford/vowpal_wabbit/pull/1533
  patches = [
    ./vowpal-wabbit-find-boost.diff
  ];

  # vw tries to write some explicit things to home
  # python installed: The directory '/homeless-shelter/.cache/pip/http'
  preInstall = ''
    export HOME=$PWD
  '';

  buildInputs = [ python.pkgs.boost zlib.dev clang ncurses pytest docutils pygments ];
  propagatedBuildInputs = [ numpy scipy scikitlearn ];

  # Python ctypes.find_library uses DYLD_LIBRARY_PATH.
  preConfigure = lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="${python.pkgs.boost}/lib"
  '';

  checkPhase = ''
    # check-manifest requires a git clone, not a tarball
    # check-manifest --ignore "Makefile,PACKAGE.rst,*.cc,tox.ini,tests*,examples*,src*"
    ${python.interpreter} setup.py check -mrs
  '';

  meta = with lib; {
    description = "Vowpal Wabbit is a fast machine learning library for online learning, and this is the python wrapper for the project.";
    homepage    = https://github.com/JohnLangford/vowpal_wabbit;
    license     = licenses.bsd3;
    broken      = stdenv.isAarch64;
    maintainers = with maintainers; [ teh ];
  };
}
