{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  python-dotenv,
  pyyaml,
  schema,
  toml,
  typer,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "typer-config";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxb2";
    repo = "typer-config";
    tag = finalAttrs.version;
    hash = "sha256-gWe4Eo4WyjpQ3ZHzp1sIIo0L/EfnZMwR6EKfPtYSKuY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.7.19,<0.11.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ typer ];

  optional-dependencies = {
    all = [
      python-dotenv
      pyyaml
      toml
    ];
    python-dotenv = [ python-dotenv ];
    toml = [ toml ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
    schema
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "typer_config" ];

  disabledTestPaths = [
    # Don't test the example
    "tests/test_example.py"
  ];

  meta = {
    description = "Utilities for working with configuration files in typer CLIs";
    homepage = "https://github.com/maxb2/typer-config";
    changelog = "https://github.com/maxb2/typer-config/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
