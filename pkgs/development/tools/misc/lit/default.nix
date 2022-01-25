{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "lit";
  version = "13.0.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "4da976f3d114e4ba6ba06cbe660ce1393230f4519c4df15b90bc1840f00e4195";
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
