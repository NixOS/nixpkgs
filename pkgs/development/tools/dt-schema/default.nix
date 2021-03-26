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
  version = "2021.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99972a8ef3f8840aa6b92535edbd680e08a79fa3e9533e35831d6ba60eb4a381";
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

