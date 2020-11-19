{ lib
, buildPythonPackage
, fetchPypi
, git
, ruamel_yaml
, jsonschema
, rfc3987
, setuptools
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "dtschema";
  version = "2020.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad052d293eadb5b64631bfffac62c496427ad4105e76eef19a5422ba762ee734";
  };

  nativeBuildInputs = [ setuptools_scm git ];
  propagatedBuildInputs = [
    setuptools
    ruamel_yaml
    jsonschema
    rfc3987
  ];

  meta = with lib; {
    description = "Tooling for devicetree validation using YAML and jsonschema";
    homepage = "https://github.com/devicetree-org/dt-schema/";
    # all files have SPDX tags
    license = with licenses; [ bsd2 gpl2 ];
    maintainers = with maintainers; [ sorki ];
  };
}

