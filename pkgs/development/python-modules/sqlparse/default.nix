{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548";
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
    homepage = "https://github.com/andialbrecht/sqlparse";
    license = licenses.bsd3;
  };

}
