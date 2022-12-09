{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptoolsBuildHook
, attrs
, cattrs
, toml
, pytestCheckHook
, click
, click-option-group
}:

buildPythonPackage rec {
  pname = "typed-settings";
  version = "1.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fbo4oj84j7Vkz2V6B/EqoyRl9OutSpm5Ko9Tctu2DYM=";
  };

  nativeBuildInputs = [
    setuptoolsBuildHook
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    click-option-group
    toml
  ];

  pytestFlagsArray = [
    "tests"
  ];

  checkInputs = [
    click
    pytestCheckHook
  ];

  pythonImportsCheck = [ "typed_settings" ];

  meta = {
    description = "Typed settings based on attrs classes";
    homepage = "https://gitlab.com/sscherfke/typed-settings";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
