{ stdenv, buildPythonPackage, fetchPypi, openssl, bzip2 }:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.4";

  src = fetchPypi {
    inherit version pname;
    sha256 = "dc79a1eaad1d1cd1cf8cfe636e1bc413c60645e3e87a5a8e9b97ce882690e0e4";
  };

  buildInputs = [ openssl bzip2 ];

  meta = with stdenv.lib; {
    homepage = "https://zeroc.com/";
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more.";
    maintainers = with maintainers; [ abbradar ];
  };
}
