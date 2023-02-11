{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "15.0.6";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-S06OQfDmDyutls21HxyQ016ku3FTTsDOP8Di67d9f+k=";
  };

  passthru = {
    python = python3;
  };

  # Non-standard test suite. Needs custom checkPhase.
  # Needs LLVM's `FileCheck` and `not`: `$out/bin/lit tests`
  # There should be `llvmPackages.lit` since older LLVM versions may
  # have the possibility of not correctly interfacing with newer lit versions
  doCheck = false;

  meta = {
    description = "Portable tool for executing LLVM and Clang style test suites";
    homepage = "http://llvm.org/docs/CommandGuide/lit.html";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
