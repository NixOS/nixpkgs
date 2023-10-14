{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "5.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BKlzKzekYijs8OSWFjo+3ZNZaw5iAAKfvEiRFjhifhk=";
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
    changelog = "https://github.com/stripe/stripe-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
