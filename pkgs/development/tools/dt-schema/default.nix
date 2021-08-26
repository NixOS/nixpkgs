{ lib
, buildPythonPackage
, fetchPypi
, git
, ruamel_yaml
, jsonschema
, rfc3987
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dtschema";
  version = "2021.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-11eCRY3zptsXI4kAIz3jLrTON4j2QTz/xG7vgUgyVA0=";
  };

  nativeBuildInputs = [ setuptools-scm git ];
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

