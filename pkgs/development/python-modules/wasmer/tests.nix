{ buildPythonPackage
, wasmer
, pytestCheckHook
, wasmer-compiler-cranelift
, wasmer-compiler-llvm
, wasmer-compiler-singlepass
}:

buildPythonPackage rec {
  pname = "wasmer-tests";
  inherit (wasmer) version;

  src = wasmer.testsout;

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    pytestCheckHook
    wasmer
    wasmer-compiler-cranelift
    wasmer-compiler-llvm
    wasmer-compiler-singlepass
  ];
}
