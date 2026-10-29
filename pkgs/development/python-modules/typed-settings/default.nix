{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  click-option-group,
  click,
  fetchPypi,
  hatch-vcs,
  hatchling,
  hypothesis,
  jinja2,
  pydantic,
  pytest-cov-stub,
  pytestCheckHook,
  python-dotenv,
  pythonAtLeast,
  rich-click,
  sybil,
}:
buildPythonPackage rec {
  pname = "typed-settings";
  version = "25.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "typed_settings";
    inherit version;
    hash = "sha256-hl61LDGE9GdwVkWh5Y251xngi515V0SKKtjLvCLtIaY=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    all = [
      attrs
      cattrs
      click
      click-option-group
      jinja2
      pydantic
    ];
    attrs = [ attrs ];
    cattrs = [ cattrs ];
    click = [ click ];
    option-groups = [
      click
      click-option-group
    ];
    jinja = [ jinja2 ];
    pydantic = [ pydantic ];
  };

  nativeBuildInputs = [ hatch-vcs ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
    python-dotenv
    rich-click
    sybil
  ]
  ++ lib.concatAttrValues optional-dependencies;

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # 1Password CLI is not available
    "TestOnePasswordLoader"
    "test_handle_op"
  ];

  disabledTestPaths = [
    # 1Password CLI is not available
    "tests/test_onepassword.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # All the CLI help messages begin with python3.14 instead of python3
    "tests/test_cli_argparse.py"
  ];

  pythonImportsCheck = [ "typed_settings" ];

  meta = {
    description = "Typed settings based on attrs classes";
    homepage = "https://gitlab.com/sscherfke/typed-settings";
    changelog = "https://gitlab.com/sscherfke/typed-settings/-/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
