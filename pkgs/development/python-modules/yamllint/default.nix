{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pathspec,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.37.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "yamllint";
    tag = "v${version}";
    hash = "sha256-CohqiBoQcgvGVP0Bt6U768BY1aIwh59YRsgzJfaDmP0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    pathspec
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # test failure reported upstream: https://github.com/adrienverge/yamllint/issues/373
    "test_find_files_recursively"
    # Issue with fixture
    "test_codec_built_in_equivalent"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # locale tests are broken on BSDs; see https://github.com/adrienverge/yamllint/issues/307
    "test_locale_accents"
    "test_locale_case"
    "test_run_with_locale"
  ];

  pythonImportsCheck = [ "yamllint" ];

  meta = with lib; {
    description = "Linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    changelog = "https://github.com/adrienverge/yamllint/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mikefaille ];
    mainProgram = "yamllint";
  };
}
