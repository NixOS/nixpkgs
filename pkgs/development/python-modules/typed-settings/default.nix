{
  lib,
  attrs,
  buildPythonPackage,
  cattrs,
  click,
  click-option-group,
  fetchPypi,
  hatchling,
  jinja2,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  tomli,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "typed-settings";
  version = "24.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "typed_settings";
    inherit version;
    hash = "sha256-BuosfIlCgCD+h7eA/6/oE98zdURaT3eik+dysBpJR+Y=";
  };

  build-system = [ hatchling ];

  dependencies = lib.optionals (pythonOlder "3.11") [ tomli ];

  passthru.optional-dependencies = {
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

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [ "tests" ];

  disabledTests = [
    # AssertionError: assert [OptionInfo(p...
    "test_deep_options"
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
    maintainers = with maintainers; [ ];
  };
}
