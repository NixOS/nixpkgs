{ stdenv, buildPythonPackage, fetchPypi
, unittest2, mock, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "1.77.2";
  name = "${pname}-${version}";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bcd55108dd2c0e853a91147ee843bc375f35767e64d0f7680e5bd82ddb7fbf1";
  };

  buildInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
