{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180509.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11d9c4a07565358e6ee001f5c57c8393b4aaadac0d993a0a39a0387a33644fba";
  };

  propagatedBuildInputs = [ user-agents ];
}
