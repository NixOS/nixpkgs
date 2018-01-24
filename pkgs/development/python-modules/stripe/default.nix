{ stdenv, buildPythonPackage, fetchPypi
, unittest2, mock, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "1.77.1";
  name = "${pname}-${version}";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1c638b417301849ff4ee0327332cfdec96edda83c79b08af307339138077d59";
  };

  buildInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
