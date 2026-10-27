{
  buildPythonPackage,
  stestr,
  stestrCheckHook,
  writableTmpDirAsHomeHook,
  ddt,
}:

buildPythonPackage {
  pname = "stestr-tests";
  inherit (stestr) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;
  preConfigure = ''
    pythonOutputDistPhase() { touch $dist; }
  '';

  nativeCheckInputs = [
    stestrCheckHook
    writableTmpDirAsHomeHook
    ddt
  ];

  stestrFlags = [
    "--test-path"
    "stestr/tests"
  ];
}
