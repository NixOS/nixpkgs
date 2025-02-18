{
  lib,
  buildPythonPackage,
  colorama,
  colorclass,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  termcolor,
}:

buildPythonPackage rec {
  pname = "terminaltables3";
  version = "4.0.0-unstable-2024-07-21";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "matthewdeanmartin";
    repo = "terminaltables3";
    #rev = "refs/tags/v${version}";
    rev = "f1c465b36eb9b91a984d8864b21376e7c37075b8";
    hash = "sha256-UcEovh1Eb4QNPwLGDjCphPlJSSkOdhCJ2fK3tuSWOTc=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    colorama
    colorclass
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    termcolor
  ];

  pythonImportsCheck = [ "terminaltables3" ];

  disabledTests = [
    # Tests are comparing CLI output
    "test_color"
    "test_colors"
    "test_height"
    "test_width"
  ];

  meta = {
    description = "Generate simple tables in terminals from a nested list of strings";
    homepage = "https://github.com/matthewdeanmartin/terminaltables3";
    changelog = "https://github.com/matthewdeanmartin/terminaltables3/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
