{ stdenv, buildPythonPackage, fetchPypi, openssl, bzip2 }:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.3";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1adec3b54c77c46acfc8a99d6336ce9a0223a7016852666358133cbe37d99744";
  };

  buildInputs = [ openssl bzip2 ];

  meta = with stdenv.lib; {
    homepage = https://zeroc.com/;
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more.";
    maintainers = with maintainers; [ abbradar ];
  };
}
