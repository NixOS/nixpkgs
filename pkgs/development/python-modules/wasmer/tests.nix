{
  buildPythonPackage,
  wasmer,
  pytestCheckHook,
  wasmer-compiler-cranelift,
  wasmer-compiler-llvm,
  wasmer-compiler-singlepass,
}:

buildPythonPackage {
  pname = "wasmer-tests";
  inherit (wasmer) version;

  src = wasmer.testsout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pytestCheckHook
    wasmer
    wasmer-compiler-cranelift
    wasmer-compiler-llvm
    wasmer-compiler-singlepass
  ];
}
