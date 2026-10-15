{
  buildPythonPackage,
  sphinx,
  stestrCheckHook,
  stevedore,
}:

buildPythonPackage {
  pname = "stevedore-tests";
  inherit (stevedore) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    sphinx
    stestrCheckHook
    stevedore
  ];
}
