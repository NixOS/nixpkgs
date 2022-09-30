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
  version = "1.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ja2ZLqzJSSvK5hIMhayMztJta/Jc3tmb2tzdlxageAs=";
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
