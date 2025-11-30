{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  click,
  click-option-group,
  fetchPypi,
  hatch-vcs,
  hatchling,
  hypothesis,
  jinja2,
  pydantic,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  rich-click,
  sybil,
  tomli,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "typed-settings";
  version = "25.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "typed_settings";
    inherit version;
    hash = "sha256-Kbr9Mc1PXgD+OAw/ADp3HXC+rnAJcFEqjlXxQq/1wRM=";
  };

  build-system = [ hatchling ];

  dependencies = lib.optionals (pythonOlder "3.11") [ tomli ];

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
    rich-click
    sybil
  ]
  ++ (lib.optional (pythonOlder "3.11") typing-extensions)
  ++ (lib.concatAttrValues optional-dependencies);

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # 1Password CLI is not available
    "TestOnePasswordLoader"
    "test_handle_op"
  ];

  disabledTestPaths = [
    # 1Password CLI is not available
    "tests/test_onepassword.py"
  ];

  pythonImportsCheck = [ "typed_settings" ];

  meta = with lib; {
    description = "Typed settings based on attrs classes";
    homepage = "https://gitlab.com/sscherfke/typed-settings";
    changelog = "https://gitlab.com/sscherfke/typed-settings/-/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
