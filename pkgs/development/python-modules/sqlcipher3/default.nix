{ buildPythonPackage, fetchPypi, lib, sqlcipher }:

buildPythonPackage rec {
  pname = "sqlcipher3";
  version = "0.5.0";

  propagatedBuildInputs = [ sqlcipher ];

  doCheck = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+wa7UzaCWvIE6Obb/Ihema8UnFPr2P+HeDe1R4+iU+U=";
  };

  meta = with lib; {
    description = "Python 3 bindings for SQLCipher";
    homepage = "https://github.com/coleifer/sqlcipher3";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ qbit ];
  };
}
