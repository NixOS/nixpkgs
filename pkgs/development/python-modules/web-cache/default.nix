{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "web-cache";
  version = "1.1.0";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "web_cache";
    sha256 = "1d8f1s3i0s3h1jqvjq6cp639hhbbpxvyq7cf9dwzrvvvr0s0m8fm";
  };

  # No tests in downloaded archive
  doCheck = false;

  pythonImportsCheck = [ "web_cache" ];

  meta = with lib; {
    description = "Simple Python key-value storage backed up by sqlite3 database";
    homepage = "https://github.com/desbma/web_cache";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ moni ];
  };
}
