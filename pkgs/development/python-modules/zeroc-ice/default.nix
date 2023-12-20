{ stdenv, lib, buildPythonPackage, fetchPypi, openssl, bzip2 }:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-MOVsYfUq3n62hPEUIOGA75RviGofHcXaJKMnYERxg74=";
  };

  buildInputs = [ openssl bzip2 ];

  pythonImportsCheck = [ "Ice" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://zeroc.com/";
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more.";
    maintainers = with maintainers; [ abbradar ];
  };
}
