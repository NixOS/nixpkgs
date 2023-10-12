{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytz
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

  pythonImportsCheck = [ "snaptime" ];

  # no tests on Pypi, no tags on github
  doCheck = false;

  meta = with lib; {
    description = "Transform timestamps with a simple DSL";
    homepage = "https://github.com/zartstrom/snaptime";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
