{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.63.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "816c935e31d82737a9e4362c662e8702bdf9000ea1bd36882cd4cbd23eb81ae1";
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
