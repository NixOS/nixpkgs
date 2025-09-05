{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build system
  hatchling,

  # dependencies
  numpy,
  pillow,
  six,
  httpx,

  # test dependencies
  freezegun,
  pytest-httpx,
  python-dotenv,
  pytest-mock,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tuya-vacuum";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaidenlabelle";
    repo = "tuya-vacuum";
    tag = "v${version}";
    hash = "sha256-/hg6UfdNBHwotgkYriV3FGVjWsvlU80WJFLszAGPs3c=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    numpy
    pillow
    six
    httpx
  ];

  nativeCheckInputs = [
    pytestCheckHook

    # test dependencies
    freezegun
    pytest-httpx
    python-dotenv
    pytest-mock
  ];

  pythonImportsCheck = [
    "tuya_vacuum"
  ];

  meta = {
    description = "Python library to get maps from Tuya robot vacuums ";
    homepage = "https://github.com/jaidenlabelle/tuya-vacuum";
    changelog = "https://github.com/jaidenlabelle/tuya-vacuum/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cholli ];
  };
}
