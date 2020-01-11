{ stdenv, buildPythonPackage, isPy3k, fetchPypi, voluptuous, pytest }:

buildPythonPackage rec  {
  pname = "voluptuous-serialize";
  version = "2.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xcjyp1190z6a226fg0clvhf43gjsbyn60amblsg7w7cw86d033l";
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
