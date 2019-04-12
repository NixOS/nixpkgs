{ lib, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "0.8.0";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0lwx1w1vk3a0pc237chwycl8qc6lwq8bzf13036wnmk74m9kwi7c";
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
