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
  version = "1.35.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "yamllint";
    rev = "refs/tags/v${version}";
    hash = "sha256-+7Q2cPl4XElI2IfLAkteifFVTrGkj2IjZk7nPuc6eYM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    pathspec
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests =
    [
      # test failure reported upstream: https://github.com/adrienverge/yamllint/issues/373
      "test_find_files_recursively"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # locale tests are broken on BSDs; see https://github.com/adrienverge/yamllint/issues/307
      "test_locale_accents"
      "test_locale_case"
      "test_run_with_locale"
    ];

  pythonImportsCheck = [ "yamllint" ];

  meta = with lib; {
    description = "Linter for YAML files";
    mainProgram = "yamllint";
    homepage = "https://github.com/adrienverge/yamllint";
    changelog = "https://github.com/adrienverge/yamllint/blob/v${version}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      jonringer
      mikefaille
    ];
  };
}
