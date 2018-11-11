{ lib, buildPythonPackage, fetchPypi, isPy3k
, unittest2, mock, requests, simplejson }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.11.1";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "558505e7c5ce2adc9e21928e2fab28ccf7f0994c20ba6cda3f8342fd9a276c49";
  };

  checkInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ] ++ lib.optional (!isPy3k) simplejson;

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
