{ lib
, attrs
, buildPythonPackage
, cattrs
, click
, click-option-group
, fetchPypi
, hatchling
, pytestCheckHook
, pythonOlder
, tomli
, typing-extensions
}:

buildPythonPackage rec {
  pname = "typed-settings";
  version = "23.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "typed_settings";
    inherit version;
    hash = "sha256-0esWiZ0dVnIJ+TDSD+0+zq63I1JcKH3iVe34pFRQX9U=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    click-option-group
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    click = [
      click
    ];
  };

  checkInputs = [
    pytestCheckHook
    typing-extensions
  ] ++ passthru.optional-dependencies.click;

  pytestFlagsArray = [
    "tests"
  ];

  disabledTests = [
    # AssertionError: assert [OptionInfo(p...
    "test_deep_options"
  ];

  pythonImportsCheck = [
    "typed_settings"
  ];

  meta = {
    description = "Typed settings based on attrs classes";
    homepage = "https://gitlab.com/sscherfke/typed-settings";
    changelog = "https://gitlab.com/sscherfke/typed-settings/-/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
