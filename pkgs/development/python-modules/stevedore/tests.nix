{
  buildPythonPackage,
  docutils,
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
    docutils
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
