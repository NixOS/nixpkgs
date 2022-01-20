{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.64.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f4b2175046104e4fcd8a2689a68bb9828a857814126d2ed13772cf2554fb93e";
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
