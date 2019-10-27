{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wxqrm9fpn4phz6rqm7kfd1wwkwzx376gs27nnalwx12q0lwlgbw";
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
