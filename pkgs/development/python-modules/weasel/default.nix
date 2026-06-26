{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudpathlib,
  confection,
  httpx,
  pydantic,
  smart-open,
  srsly,
  typer,
  wasabi,

  # tests
  pytestCheckHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "weasel";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "weasel";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-yiLoLdnDfKby1Ez1hKGL9DxazQto57Zn0DlRmGLurOs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cloudpathlib
    confection
    httpx
    pydantic
    smart-open
    srsly
    typer
    wasabi
  ];

  pythonImportsCheck = [ "weasel" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # These tests require internet access
    "test_project_assets"
    "test_project_git_dir_asset"
    "test_project_git_file_asset"

    # configparser.InterpolationMissingOptionError: Bad value substitution: option 'commands' in
    # section 'project' contains an interpolation key 'vars.b.e' which is not a valid option name.
    # Raw value: '[{"name": "x", "script": ["hello ${vars.a} ${vars.b.e}"]}]'
    "test_project_config_interpolation"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-v(.*)"
      ];
    };
  };

  meta = {
    description = "Small and easy workflow system";
    homepage = "https://github.com/explosion/weasel/";
    changelog = "https://github.com/explosion/weasel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "weasel";
  };
})
