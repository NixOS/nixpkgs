{ lib
, buildPythonPackage
, fetchPypi
, git
, ruamel-yaml
, jsonschema
, rfc3987
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dtschema";
  version = "2022.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G5KzuaMbbkuLK+cNvzBld1UwvExS6ZGVW2e+GXQRFMU=";
  };

  nativeBuildInputs = [ setuptools-scm git ];
  propagatedBuildInputs = [
    setuptools
    ruamel-yaml
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

