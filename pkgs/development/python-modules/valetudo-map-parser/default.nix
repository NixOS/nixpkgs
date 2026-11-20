{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mvcrender,
  numpy,
  pillow,
  poetry-core,
  psutil,
  pytest-asyncio,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "valetudo-map-parser";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sca075";
    repo = "Python-package-valetudo-map-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NZlWON+1H+sgYXQmzwj6q8P7O+04+GBah3BiNQk+ZD0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mvcrender
    numpy
    pillow
    scipy
  ];

  nativeCheckInputs = [
    psutil
    pytest-asyncio
    pytestCheckHook
  ];

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
