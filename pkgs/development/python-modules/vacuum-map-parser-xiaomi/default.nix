{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pillow,
  pycryptodome,
  vacuum-map-parser-base,
}:

buildPythonPackage (finalAttrs: {
  pname = "vacuum-map-parser-xiaomi";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aronkahrs-us";
    repo = "Python-package-vacuum-map-parser-xiaomi";
    tag = finalAttrs.version;
    hash = "sha256-ZZvmi7l7/hn8/xcccAA0lEE1F7Eic247lREvffQ34SA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pillow
    pycryptodome
    vacuum-map-parser-base
  ];

  doCheck = false;

  pythonImportsCheck = [ "vacuum_map_parser_xiaomi" ];

  meta = {
    description = "Functionalities for Xiaomi vacuum map parsing";
    homepage = "https://github.com/aronkahrs-us/Python-package-vacuum-map-parser-xiaomi";
    changelog = "https://github.com/aronkahrs-us/Python-package-vacuum-map-parser-xiaomi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
