{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wassima";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "wassima";
    tag = finalAttrs.version;
    hash = "sha256-uH8UBsdqnPbGyQX/Tn5Ct3vcbfLEyUC8pDSCM4PwWZg=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "wassima" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tests connect to the internet
  doCheck = false;

  meta = {
    changelog = "https://github.com/jawah/wassima/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Access your OS root certificates with utmost ease";
    homepage = "https://github.com/jawah/wassima";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
