{ lib, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "0.7.1";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "ecef2833aef7f411cb923dac109c7c9dcc7dbe7cafce0650c1e8d19c243d955f";
  };

  # Non-standard test suite. Needs custom checkPhase.
  doCheck = false;

  meta = {
    description = "Portable tool for executing LLVM and Clang style test suites";
    homepage = http://llvm.org/docs/CommandGuide/lit.html;
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
