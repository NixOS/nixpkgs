{ lib
, buildPythonPackage
, fetchPypi
, pbr
, python_mimeparse
, extras
, lxml
, unittest2
, traceback2
, isPy3k
}:

buildPythonPackage rec {
  pname = "testtools";
  version = "1.8.0";
  name = "${pname}-${version}";

  # Python 2 only judging from SyntaxError
#   disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15yxz8d70iy1b1x6gd7spvblq0mjxjardl4vnaqasxafzc069zca";
  };

  propagatedBuildInputs = [ pbr python_mimeparse extras lxml unittest2 ];
  buildInputs = [ traceback2 ];
  patches = [ ./testtools_support_unittest2.patch ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "A set of extensions to the Python standard library's unit testing framework";
    homepage = http://pypi.python.org/pypi/testtools;
    license = lib.licenses.mit;
  };
}