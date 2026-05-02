{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "tstr";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ilotoki0804";
    repo = "tstr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vQ+PNbcrBRSskQDRwD++135SEIzbYKHDcy87Qj2oMNg=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "tstr" ];

  meta = {
    description = "Backports of various template string utilities";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
