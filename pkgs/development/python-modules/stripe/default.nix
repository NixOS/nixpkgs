{ lib, buildPythonPackage, fetchPypi, isPy3k
, unittest2, mock, requests, simplejson }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.21.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "170f76f2502888debf02da580138c840497b9359876ca3838f4692f2f02c9110";
  };

  checkInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ] ++ lib.optional (!isPy3k) simplejson;

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
