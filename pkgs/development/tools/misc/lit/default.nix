{ lib, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "0.5.1";
  name = "${pname}-${version}";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0z651m3vkbk85y41larnsjxrszkbi58x9gzml3lb6ga7qwcrsg97";
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
