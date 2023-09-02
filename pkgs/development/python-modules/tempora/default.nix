{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, jaraco-functools
, pytest-freezegun
, pytestCheckHook
, pythonOlder
, pytz
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "5.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E+T8yZfQUJwzBtaEHwPpOBt+Xkayvr+ukVGvkAhfDCY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaraco-functools
    pytz
  ];

  nativeCheckInputs = [
    freezegun
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tempora"
    "tempora.schedule"
    "tempora.timing"
    "tempora.utc"
  ];

  meta = with lib; {
    description = "Objects and routines pertaining to date and time";
    homepage = "https://github.com/jaraco/tempora";
    changelog = "https://github.com/jaraco/tempora/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
