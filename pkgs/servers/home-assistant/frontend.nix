{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180404.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac36d4f5e30e93b02dadd2ecdc07218fde3d97ffc2f69a6f1acf5e601cd4e5ad";
  };

  propagatedBuildInputs = [ user-agents ];
}
