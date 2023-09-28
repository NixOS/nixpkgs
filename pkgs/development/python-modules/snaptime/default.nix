{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytz
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "snaptime";
  version = "0.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4/HriQQ9WNMHIauYy2UCPxpMJ0DjsZdwQpixY8ktUIs=";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [
    "snaptime"
  ];

  doCheck = false; # git has tests, but no tags :(

  meta = with lib; {
    description = "Transform timestamps with a simple DSL";
    homepage = "https://github.com/zartstrom/snaptime";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
