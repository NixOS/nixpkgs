{ stdenv, buildPythonPackage, isPy3k, fetchPypi, voluptuous, pytest }:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "44be04d87aec34bd7d31ab539341fadc505205f2299031ed9be985112c21aa41";
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
