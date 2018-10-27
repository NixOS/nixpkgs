{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08dszglfhf1c4rwqinkbp4x55v0b90rgm1fxc1l4dy965imjjinl";
  };

  buildInputs = [ pytest ];
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
