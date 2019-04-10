{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c3dca29c022744e95b547e867cee89f4fce4373f3549ccd8797d8eb52cdb873";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Non-validating SQL parser for Python";
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = https://github.com/andialbrecht/sqlparse;
    license = licenses.bsd3;
  };

}
