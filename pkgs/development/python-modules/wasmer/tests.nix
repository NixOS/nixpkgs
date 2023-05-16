{ buildPythonPackage
, wasmer
, pytestCheckHook
, wasmer-compiler-cranelift
, wasmer-compiler-llvm
, wasmer-compiler-singlepass
}:

<<<<<<< HEAD
buildPythonPackage {
=======
buildPythonPackage rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
