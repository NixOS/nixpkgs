{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "14.0.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "45e08ce87b0ea56ab632aa02fa857418a5dd241a711c7c756878b73a130c3efe";
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
