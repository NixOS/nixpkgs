{ lib, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "0.6.0";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1png3jgbhrw8a602gy6rnzvjcrj8w2p2kk6szdg9lz42zr090lgb";
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
