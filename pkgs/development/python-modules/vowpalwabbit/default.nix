{ stdenv, lib, buildPythonPackage, fetchPypi, python, zlib, clang
, ncurses, pytest, docutils, pygments, numpy, scipy, scikitlearn }:

buildPythonPackage rec {
  pname = "vowpalwabbit";
  version = "8.7.0.post1";

  src = fetchPypi{
    inherit pname version;
    sha256 = "de9529660858b380127b2bea335b41a29e8f264551315042300022eb4e6524ea";
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

  nativeBuildInputs = [ clang ];
  buildInputs = [ python.pkgs.boost zlib.dev ncurses pytest docutils pygments ];
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
