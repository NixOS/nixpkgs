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
  version = "2021.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9f88f069068dc5dc7e895785d7172d260cbbc34cab3b52704b20e89b80c6de8";
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

