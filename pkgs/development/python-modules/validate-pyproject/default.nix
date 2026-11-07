{
  lib,
  buildPythonPackage,
  fastjsonschema,
  fetchFromGitHub,
  nix-update-script,
  packaging,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  tomli,
  trove-classifiers,
  validate-pyproject-schema-store,
}:

buildPythonPackage (finalAttrs: {
  pname = "validate-pyproject";
  version = "0.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abravalheri";
    repo = "validate-pyproject";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D56oopd55qV1yMarAXQ7OWXau+zevGdCBsOQt8fGFBU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ fastjsonschema ];

  optional-dependencies = {
    all = [
      packaging
      tomli
      trove-classifiers
    ];
    store = [ validate-pyproject-schema-store ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "validate_pyproject" ];

  disabledTests =
    let
      examples = [
        "atoml/pyproject.toml"
        "cibuildwheel/default.toml"
        "cibuildwheel/overrides.toml"
        "flit/pyproject.toml"
        "localtool/working.toml"
        "pdm/pyproject.toml"
        "pep_text/pyproject.toml"
        "poetry/poetry-author-no-email.toml"
        "poetry/poetry-capital-in-author-email.toml"
        "poetry/poetry-complete.toml"
        "poetry/poetry-inline-table.toml"
        "poetry/poetry-readme-files.toml"
        "poetry/poetry-sample-project.toml"
        "ruff/modern.toml"
        "setuptools/01-pyproject.toml"
        "setuptools/02-pyproject.toml"
        "setuptools/03-pyproject.toml"
        "setuptools/04-pyproject.toml"
        "setuptools/05-pyproject.toml"
        "setuptools/06-pyproject.toml"
        "setuptools/07-pyproject.toml"
        "setuptools/08-pyproject.toml"
        "setuptools/09-pyproject.toml"
        "setuptools/10-pyproject.toml"
        "setuptools/11-pyproject.toml"
        "setuptools/12-pyproject.toml"
        "setuptools/readme-pyproject.toml"
        "simple/depgroups.toml"
        "simple/dynamic-version.toml"
        "simple/empty-author.toml"
        "simple/import_names.toml"
        "simple/minimal.toml"
        "simple/partially-dynamic-entry-points.toml"
        "simple/partially-dynamic-tables.toml"
        "simple/partially-dynamic.toml"
        "simple/pep639.toml"
        "store/example.toml"
        "trampolim/pyproject.toml"
      ];
    in
    [
      # Tests require network access
      "test_cache_open_url"
      "test_invalid_examples_api"
      "test_invalid_examples_cli"
      "TestClassifiers::test_downloaded"
      "test_list_from_entry_points"
      # fastjsonschema does not support all JSON Schema formats used by validate-pyproject
      "TestValidator::test_valid"
      "TestValidator::test_invalid"
      "TestDisable::test_valid"
      "TestDisable::test_invalid"
      "TestDisable::test_invalid_disabled"
      "TestInput::test_inform_user_about_stdin"
      "TestOutput::test_valid"
      "TestOutput::test_invalid"
      "test_multiple_files"
      "test_pre_compile_api"
      "test_vendoring_cli"
      "test_valid_example[atoml]"
      "test_valid_example[flit]"
      "test_valid_example[pdm]"
      "test_valid_example[pep_text]"
      "test_valid_example[trampolim]"
      "test_invalid_example[pdm/invalid-version]"
      "test_invalid_example[pdm/redefining-as-dynamic]"
      "test_no_distutils"
      "test_has_distutils"
      "test_api"
      "test_cli"
      "test_main"
    ]
    ++ lib.concatMap (example: [
      "test_examples_api[${example}]"
      "test_examples_cli[${example}]"
      "test_examples_api[${example}-api_pre_compile]"
      "test_examples_api[${example}-cli_pre_compile]"
    ]) examples
    ++ [ "test_downloaded" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Validation library for simple check on pyproject.toml";
    homepage = "https://github.com/abravalheri/validate-pyproject";
    changelog = "https://github.com/abravalheri/validate-pyproject/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
