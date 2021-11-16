{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.62.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fb51d67a961ea889c5be324f020535ed511c6f483bd13a07f48f6e369fa8df0";
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
