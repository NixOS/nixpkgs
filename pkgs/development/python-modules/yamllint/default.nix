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
  version = "1.37.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "yamllint";
    tag = "v${version}";
    hash = "sha256-874VqcJyHMVIvrR3qzL2H7/Hz7qRb7GDWI56SAdCz00=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    pathspec
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests =
    [
      # test failure reported upstream: https://github.com/adrienverge/yamllint/issues/373
      "test_find_files_recursively"
      # Issue wih fixture
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
    changelog = "https://github.com/adrienverge/yamllint/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mikefaille ];
    mainProgram = "yamllint";
  };
}
