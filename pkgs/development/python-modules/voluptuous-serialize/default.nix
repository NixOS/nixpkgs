{ stdenv, buildPythonPackage, isPy3k, fetchPypi, voluptuous, pytest }:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ggiisrq7cbk307d09fdwfdcjb667jv90lx6gfwhxfpxgq66cccb";
  };

  propagatedBuildInputs = [
    voluptuous
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    py.test
  '';

  # no tests in PyPI tarball
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/balloob/voluptuous-serialize;
    license = licenses.asl20;
    description = "Convert Voluptuous schemas to dictionaries so they can be serialized";
    maintainers = with maintainers; [ etu ];
  };
}
