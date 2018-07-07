{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180704.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb6c0f330e4320092de708750675e3e973038a8b05928734b71a38d5a3ee66cf";
  };

  propagatedBuildInputs = [ user-agents ];
}
