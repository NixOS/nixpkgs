{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  pytestCheckHook,

  hatchling,

  numpy,
  mypy,

  typing-extensions,
}:

buildPythonPackage rec {
  pname = "typing-validation";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "hashberg-io";
    repo = "typing-validation";
    tag = "v${version}";
    hash = "sha256-zOVMSutuRh3+7hNB36NGBqHToxYD3QohTAMPWQcSjD8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling ==" "hatchling >="
  '';

  build-system = [
    hatchling
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    mypy
  ];

  pythonImportsCheck = [ "typing_validation" ];

  meta = {
    description = "Simple library for runtime type-checking";
    homepage = "https://github.com/hashberg-io/typing-validation";
    changelog = "https://github.com/hashberg-io/typing-validation/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
