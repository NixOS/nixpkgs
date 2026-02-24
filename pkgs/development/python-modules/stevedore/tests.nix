{
  buildPythonPackage,
  sphinx,
  stestr,
  stevedore,
}:

buildPythonPackage {
  pname = "stevedore-tests";
  inherit (stevedore) version src;
  format = "other";

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    sphinx
    stestr
    stevedore
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';
}
