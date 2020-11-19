{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, python
}:

buildPythonPackage rec {
  pname = "sqlalchemy-citext";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69ba00f5505f92a1455a94eefc6d3fcf72dda3691ab5398a0b4d0d8d85bd6aab";
  };

  propagatedBuildInputs = [
    sqlalchemy
  ];

  # tests are not packaged in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "citext" ];

  meta = with lib; {
    description = "A sqlalchemy plugin that allows postgres use of CITEXT";
    homepage = "https://github.com/mahmoudimus/sqlalchemy-citext";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
