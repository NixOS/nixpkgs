{ lib, buildPythonPackage, fetchPypi, argcomplete, pyyaml, setuptools, xmltodict }:

buildPythonPackage rec {
  pname = "yq";
  version = "2.10.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "abaf2c0728f1c38dee852e976b0a6def5ab660d67430ee5af76b7a37072eba46";
  };

  propagatedBuildInputs = [ argcomplete pyyaml setuptools xmltodict ];
  
  # Test requires jq to be installed
  doCheck = false;
  
  meta = with lib; {
    description = "jq wrapper for YAML/XML documents";
    homepage = "https://github.com/kislyuk/yq";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
