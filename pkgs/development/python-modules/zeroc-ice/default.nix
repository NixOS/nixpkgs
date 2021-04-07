{ lib, buildPythonPackage, fetchPypi, openssl, bzip2 }:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.5";

  src = fetchPypi {
    inherit version pname;
    sha256 = "3b4897cc3f2adf3d03802368cedb72a038aa33c988663a667c1c48e42ea10797";
  };

  buildInputs = [ openssl bzip2 ];

  meta = with lib; {
    homepage = "https://zeroc.com/";
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more.";
    maintainers = with maintainers; [ abbradar ];
  };
}
