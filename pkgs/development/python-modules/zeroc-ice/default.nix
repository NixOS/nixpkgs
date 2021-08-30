{ lib, buildPythonPackage, fetchPypi, openssl, bzip2 }:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.6";

  src = fetchPypi {
    inherit version pname;
    sha256 = "e8d8a7828e4994545bf57059bd0a0d431d387d31cc4af2eb5eeb93ef28c2d827";
  };

  buildInputs = [ openssl bzip2 ];

  pythonImportsCheck = [ "Ice" ];

  meta = with lib; {
    homepage = "https://zeroc.com/";
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more.";
    maintainers = with maintainers; [ abbradar ];
  };
}
