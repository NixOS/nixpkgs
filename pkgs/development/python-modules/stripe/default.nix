{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.70.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7YiX9o5rrDOYzJmOtWNFUYQGMNZQTAAm/P0K2RyadKQ=";
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
