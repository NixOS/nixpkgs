{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, attrs
, anyio
}:

buildPythonPackage rec {
  pname = "semaphore-bot";
  version = "0.17.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-3zb6+HdOB6+YrVRcmIHsokFKUOlFmKCoVNllvM+aOXQ=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "anyio>=3.5.0,<=3.6.2" "anyio"
  '';

  propagatedBuildInputs = [
    anyio
    attrs
    python-dateutil
  ];

  # Upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "semaphore" ];

  meta = with lib; {
    description = "Simple rule-based bot library for Signal Private Messenger";
    homepage = "https://github.com/lwesterhof/semaphore";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ onny ];
  };
}
