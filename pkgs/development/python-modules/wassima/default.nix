{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wassima";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "wassima";
    tag = version;
    hash = "sha256-MUGB8x4+G+B4cknCeiCcTqKwa8Gea8QrRyM4sYbVxdA=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "wassima" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tests connect to the internet
  doCheck = false;

  meta = {
    changelog = "https://github.com/jawah/wassima/blob/${src.tag}/CHANGELOG.md";
    description = "Access your OS root certificates with utmost ease";
    homepage = "https://github.com/jawah/wassima";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
