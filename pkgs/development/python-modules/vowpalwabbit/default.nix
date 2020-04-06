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
, scikitlearn }:

buildPythonPackage rec {
  pname = "vowpalwabbit";
  version = "8.8.1";

  src = fetchPypi{
    inherit pname version;
    sha256 = "17fw1g4ka9jppd41srw39zbp2b8h81izc71bbggxgf2r0xbdpga6";
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
    scikitlearn
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
