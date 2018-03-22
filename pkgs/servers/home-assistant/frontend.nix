{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180310.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a7cca7ed461d650859df7d036ff4c579366bbcde5eb6407b1aff6a0dbbae2c2";
  };

  propagatedBuildInputs = [ user-agents ];
}
