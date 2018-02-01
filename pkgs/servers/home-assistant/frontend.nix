{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180130.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b9klisl7hh30rml8qlrp9gpz33z9b825pd1vxbck48k0s98z1zi";
  };
}
