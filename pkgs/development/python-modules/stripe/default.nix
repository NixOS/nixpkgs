{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.75.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iAjXsbeX+vZW8FtaJRIB5lR3EEkDUU/dPpLpdHSxLME=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Tests require network connectivity and there's no easy way to disable them
  doCheck = false;

  pythonImportsCheck = [
    "stripe"
  ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
