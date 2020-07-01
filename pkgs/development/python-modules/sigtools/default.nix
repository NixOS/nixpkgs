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
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b890f22ece64bc47d3d4e84c950581e83917794a6cf1548698145590e221aff";
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
