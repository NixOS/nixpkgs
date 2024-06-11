{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.0.1";
  format = "setuptools";
  pname = "unittest-data-provider";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gn2ka4vqpayx4cpbp8712agqjh3wdpk9smdxnp709ccc2v7zg46";
  };

  meta = with lib; {
    description = "PHPUnit-like @dataprovider decorator for unittest";
    homepage = "https://github.com/yourlabs/unittest-data-provider";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
