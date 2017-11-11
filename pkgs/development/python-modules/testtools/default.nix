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
, fixtures
, pyrsistent
}:

# testtools 2.0.0 and up has a circular run-time dependency on futures

buildPythonPackage rec {
  pname = "testtools";
  version = "1.9.0";
  name = "${pname}-${version}";

  # Python 2 only judging from SyntaxError
#   disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b46eec2ad3da6e83d53f2b0eca9a8debb687b4f71343a074f83a16bbdb3c0644";
  };

  propagatedBuildInputs = [ pbr python_mimeparse extras lxml unittest2 pyrsistent ];
  buildInputs = [ traceback2 ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "A set of extensions to the Python standard library's unit testing framework";
    homepage = https://pypi.python.org/pypi/testtools;
    license = lib.licenses.mit;
  };
}