{ lib, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "0.5.0";
  name = "${pname}-${version}";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "3ea4251e78ebeb2e07be2feb33243d1f8931d956efc96ccc2b0846ced212b58c";
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
