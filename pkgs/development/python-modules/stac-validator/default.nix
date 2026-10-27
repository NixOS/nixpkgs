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
  version = "4.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StacLabs";
    repo = "stac-validator";
    tag = "v${version}";
    hash = "sha256-H4vhinsfOY4kM2YRGJrl8+9Wj91gKo5aj8sTZV/LHX0=";
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
    homepage = "https://github.com/StacLabs/stac-validator";
    license = lib.licenses.asl20;
    teams = [ lib.teams.geospatial ];
  };
}
