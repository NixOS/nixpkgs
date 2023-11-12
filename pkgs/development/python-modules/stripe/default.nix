{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "stripe";
  version = "7.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pcfdgjk20yYt1DCr5XQ4rzLokQNS27NOspa/21nvCuw=";
  };

  propagatedBuildInputs = [
    requests
    typing-extensions
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
