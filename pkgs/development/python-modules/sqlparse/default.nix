{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  # Package supports 3.x, but tests are clearly 2.x only.
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "Non-validating SQL parser for Python";
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = https://github.com/andialbrecht/sqlparse;
    license = licenses.bsd3;
  };

}
