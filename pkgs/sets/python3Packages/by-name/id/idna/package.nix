{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "idna";
  version = "3.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kjd";
    repo = "idna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RLwFtWOxsf0s1DI5sdwYY/DuXbhyADqAbp0arREIc30=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "idna" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  # infinite recursion via hypothesis
  doCheck = false;

  passthru.tests = {
    pytest = finalAttrs.finalPackage.overrideAttrs {
      doInstallCheck = true;
    };
  };

  meta = {
    homepage = "https://github.com/kjd/idna/";
    changelog = "https://github.com/kjd/idna/blob/${finalAttrs.src.tag}/HISTORY.md";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
