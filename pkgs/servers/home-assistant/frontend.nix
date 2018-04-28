{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180426.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60ff4e0b0c4538fa0be0db9407f95333546940e119a8d3edb9b0d7e1c86b1f3b";
  };

  propagatedBuildInputs = [ user-agents ];
}
