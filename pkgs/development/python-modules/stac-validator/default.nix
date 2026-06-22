{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build systems
  setuptools,
  # runtime deps
  click,
  fastjsonschema,
  jsonschema,
  pyyaml,
  requests,
  tqdm,
}:
buildPythonPackage rec {
  pname = "stac-validator";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "stac-validator";
    tag = "v${version}";
    hash = "sha256-JrLpny4PDXvjKN1iQ0uxcTuPgNTykZzv7RdQDoMLQT4=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "click"
  ];

  dependencies = [
    click
    fastjsonschema
    jsonschema
    pyyaml
    requests
    tqdm
  ];

  pythonImportsCheck = [ "stac_validator" ];

  meta = {
    description = "Validator for the SpatioTemporal Asset Catalog (STAC) specification";
    homepage = "https://github.com/stac-utils/stac-validator";
    license = lib.licenses.asl20;
    teams = [ lib.teams.geospatial ];
  };
}
