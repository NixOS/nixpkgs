{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  hatchling,
}:
buildPythonPackage {
  pname = "uhashring";
  version = "2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultrabug";
    repo = "uhashring";
    tag = "2.4";
    hash = "sha256-6zNPExbcwTUne0lT8V6xp2Gf6J1VgG7Q93qizVOAc+k=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "uhashring"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Full featured consistent hashing python library compatible with ketama";
    homepage = "https://github.com/ultrabug/uhashring";
    changelog = "https://github.com/ultrabug/uhashring/blob/master/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ typedrat ];
  };
}
