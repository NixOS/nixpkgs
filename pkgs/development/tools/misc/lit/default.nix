{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "12.0.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1b5l9xjdfz4fccz6cag37lgpxjpw98a5879y3j9szy1k00hx71z1";
  };

  passthru = {
    python = python3;
  };

  # Non-standard test suite. Needs custom checkPhase.
  doCheck = false;

  meta = {
    description = "Portable tool for executing LLVM and Clang style test suites";
    homepage = "http://llvm.org/docs/CommandGuide/lit.html";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
