{ stdenv, buildPythonPackage, isPy3k, fetchPypi, voluptuous, pytest }:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d30fef4f1aba251414ec0b315df81a06da7bf35201dcfb1f6db5253d738a154f";
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
