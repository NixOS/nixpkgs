{ buildPythonPackage, fetchPypi, lib, sqlalchemy, nose }:

buildPythonPackage rec {
  pname = "sqlsoup";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mj00fhxj75ac3i8xk9jmm7hvcjz9p4x2r3yndcwsgb659rvgbrg";
  };

  propagatedBuildInputs = [ sqlalchemy ];
  nativeCheckInputs = [ nose ];

  meta = with lib; {
    description = "A one step database access tool, built on the SQLAlchemy ORM";
    homepage = "https://github.com/zzzeek/sqlsoup";
    license = licenses.mit;
    maintainers = [ maintainers.globin ];
    broken = true; # incompatible with sqlalchemy>=1.4 and unmaintained since 2016
  };
}
