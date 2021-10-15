{ lib
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
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7789628ec0d02e421bca76532b0d5da149f96f09e7ed4a5cbf318624b75e949";
  };

  buildInputs = [ repeated_test sphinx mock coverage unittest2 ];
  propagatedBuildInputs = [ funcsigs six ];

  patchPhase = ''sed -i s/test_suite="'"sigtools.tests"'"/test_suite="'"unittest2.collector"'"/ setup.py'';

  meta = with lib; {
    description = "Utilities for working with 3.3's inspect.Signature objects.";
    homepage = "https://pypi.python.org/pypi/sigtools";
    license = licenses.mit;
  };

}
