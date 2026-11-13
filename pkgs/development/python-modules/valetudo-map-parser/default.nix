{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mvcrender,
  numpy,
  pillow,
  poetry-core,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "valetudo-map-parser";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sca075";
    repo = "Python-package-valetudo-map-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9u7LnACkj6LiIFQ+JktqCTbiB4yw7Y31NwuEJlZ1FNE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mvcrender
    numpy
    pillow
    scipy
  ];

  # The upstream's test suite is not well maintained
  doCheck = false;

  pythonImportsCheck = [
    "valetudo_map_parser"
    "valetudo_map_parser.conga_handler"
    "valetudo_map_parser.hypfer_handler"
    "valetudo_map_parser.rand256_handler"
    "valetudo_map_parser.rooms_handler"
  ];

  meta = {
    description = "Parse Valetudo vacuum map data into images";
    homepage = "https://github.com/sca075/Python-package-valetudo-map-parser";
    changelog = "https://github.com/sca075/Python-package-valetudo-map-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
