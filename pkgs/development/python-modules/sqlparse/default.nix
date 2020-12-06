{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f91fd2e829c44362cbcfab3e9ae12e22badaa8a29ad5ff599f9ec109f0454e8";
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
