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
  version = "2021.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d09c94d13f46e6674ba11ff31220651ad1b02dae860f5a87905dfac6b8d768d9";
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

