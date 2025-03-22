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
  version = "1.36.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "yamllint";
    tag = "v${version}";
    hash = "sha256-AuU2bcGf5wdZAVmF9RxeastWDXnZbQLSb3GMsqKi7a4=";
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    changelog = "https://github.com/adrienverge/yamllint/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      mikefaille
    ];
  };
}
