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
  version = "0.25";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "abravalheri";
    repo = "validate-pyproject";
    tag = "v${finalAttrs.version}";
    hash = "sha256-byxghU2x8at4tAAOzIzlnnsMbvzer//0R0DNiIE4Dpk=";
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
        "cibuildwheel/default.toml"
        "cibuildwheel/overrides.toml"
        "pdm/pyproject.toml"
        "poetry/poetry-inline-table.toml"
        "poetry/poetry-author-no-email.toml"
        "poetry/poetry-readme-files.toml"
        "poetry/poetry-sample-project.toml"
        "poetry/poetry-complete.toml"
        "poetry/poetry-capital-in-author-email.toml"
        "ruff/modern.toml"
        "store/example.toml"
      ];
    in
    [
      # Tests require network access
      "test_cache_open_url"
      "test_invalid_examples_api"
      "test_invalid_examples_cli"
      "TestClassifiers::test_downloaded"
      "test_list_from_entry_points"
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
