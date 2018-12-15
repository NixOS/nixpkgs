{ stdenv
, buildPythonPackage
, fetchPypi
, repeated_test
, sphinx
, mock
, coverage
, unittest2
, funcsigs
, six
}:

buildPythonPackage rec {
  pname = "sigtools";
  version = "1.1a3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "190w14vzbiyvxcl9jmyyimpahar5b0bq69v9iv7chi852yi71w6w";
  };

  buildInputs = [ repeated_test sphinx mock coverage unittest2 ];
  propagatedBuildInputs = [ funcsigs six ];

  patchPhase = ''sed -i s/test_suite="'"sigtools.tests"'"/test_suite="'"unittest2.collector"'"/ setup.py'';

  meta = with stdenv.lib; {
    description = "Utilities for working with 3.3's inspect.Signature objects.";
    homepage = "https://pypi.python.org/pypi/sigtools";
    license = licenses.mit;
  };

}
