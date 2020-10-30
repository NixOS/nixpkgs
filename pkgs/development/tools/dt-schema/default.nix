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
  version = "2020.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c98202abb4977aac6a2995a7f4ed2f7e51739db6fd72861d29681f865c27c1b";
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

