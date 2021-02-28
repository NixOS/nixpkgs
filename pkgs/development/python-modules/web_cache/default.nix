{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "web_cache";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d8f1s3i0s3h1jqvjq6cp639hhbbpxvyq7cf9dwzrvvvr0s0m8fm";
  };

  disabled = !isPy3k;

  # web_cache doesn't have tests
  doCheck = false;

  meta = with lib; {
    description = "Simple Python key-value storage backed up by sqlite3 database";
    homepage = "https://github.com/desbma/web_cache";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
