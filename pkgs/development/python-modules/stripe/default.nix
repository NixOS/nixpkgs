{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.66.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-d8YDIjD3cUsaG0WQdPCMYNYMIpucO+rDcnGQY+PRQJw=";
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
