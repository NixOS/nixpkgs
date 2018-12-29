{ lib, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "0.7.0";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "13b32f1f1b3912bbf2bda91e9d1609abc92c0b4ce83276fe13a340516252e4b0";
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
