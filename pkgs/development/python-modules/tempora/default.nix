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
  version = "5.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ortR4hIZdtkxNHs+QzkXw2S4P91fZO8nM2yGW/H7D3U=";
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
    mainProgram = "calc-prorate";
    homepage = "https://github.com/jaraco/tempora";
    changelog = "https://github.com/jaraco/tempora/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
