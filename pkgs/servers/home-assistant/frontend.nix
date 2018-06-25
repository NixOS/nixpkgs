{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180622.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kzz1cmnpmsnrbc9amjcg8rb4a544xx2mpq4g23si6rk46b7n0x7";
  };

  propagatedBuildInputs = [ user-agents ];
}
