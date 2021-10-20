{ stdenv
, lib
, fetchPypi
, buildPythonPackage
, cmake
, python
, zlib
, ncurses
, pytest
, docutils
, pygments
, numpy
, scipy
, scikit-learn }:

buildPythonPackage rec {
  pname = "vowpalwabbit";
  version = "8.11.0";

  src = fetchPypi{
    inherit pname version;
    sha256 = "cfde0515a3fa4d224aad5461135372f3441ae1a64717ae6bff5e23509d70b0bd";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    docutils
    ncurses
    pygments
    python.pkgs.boost
    zlib.dev
  ];

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
    description = "Vowpal Wabbit is a fast machine learning library for online learning, and this is the python wrapper for the project.";
    homepage    = "https://github.com/JohnLangford/vowpal_wabbit";
    license     = licenses.bsd3;
    broken      = stdenv.isAarch64;
    maintainers = with maintainers; [ teh ];
  };
}
