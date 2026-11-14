{
  lib,
  buildPythonPackage,
  colorama,
  colorclass,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  termcolor,
}:

buildPythonPackage (finalAttrs: {
  pname = "terminaltables3";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthewdeanmartin";
    repo = "terminaltables3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UcEovh1Eb4QNPwLGDjCphPlJSSkOdhCJ2fK3tuSWOTc=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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
    changelog = "https://github.com/matthewdeanmartin/terminaltables3/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
