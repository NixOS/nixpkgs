{ stdenv, lib, buildPythonPackage, fetchPypi, openssl, bzip2 }:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.10";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-Bwn2Y/Bbu6O89iaSNWvMpXBhyJRmj6eL8j6HiPpbQbM=";
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
