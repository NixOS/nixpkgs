{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.65.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e55d4d7262085de9cef2228f14581925c35350ba58a332352b1ec9e19a7b7a6";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require network connectivity and there's no easy way to disable them
  doCheck = false;

  pythonImportsCheck = [ "stripe" ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
