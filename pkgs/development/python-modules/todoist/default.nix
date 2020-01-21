{ stdenv, fetchPypi, buildPythonPackage
, requests }:

buildPythonPackage rec {
  pname = "todoist-python";
  version = "8.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0khipf8v0gqvspq7m67aqv0ql3rdqyqr8qfhbm1szc1z6mygj8ns";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    description = "The official Todoist Python API library";
    homepage = https://todoist-python.readthedocs.io/en/latest/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
