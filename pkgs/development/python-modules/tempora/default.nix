{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build time
, setuptools-scm

# runtime
, pytz
, jaraco_functools

# tests
, freezegun
, pytest-freezegun
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "5.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-y6Dxl6ZIg78+c2V++8AyTVvxcXnndpsThbTXXSbNkSc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaraco_functools
    pytz
  ];

  checkInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
