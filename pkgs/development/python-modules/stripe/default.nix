{ lib, buildPythonPackage, fetchPypi, isPy3k
, unittest2, mock, requests, simplejson }:

buildPythonPackage rec {
  pname = "stripe";
  version = "1.82.1";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f4af86e3f556da24609543bda340db932ae1d944018003b164d530c16c27e20";
  };

  checkInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ] ++ lib.optional (!isPy3k) simplejson;

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
