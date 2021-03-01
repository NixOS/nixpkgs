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
  version = "2020.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01de2598075909f2afb2d45277d0358645066f5bbb1770fca5f1d6f399846924";
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

