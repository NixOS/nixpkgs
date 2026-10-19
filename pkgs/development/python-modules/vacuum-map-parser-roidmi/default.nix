{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pillow,
  vacuum-map-parser-base,
}:

buildPythonPackage (finalAttrs: {
  pname = "vacuum-map-parser-roidmi";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-vacuum-map-parser-roidmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E4DCvDQRrdueGnKbY3D+Oh/hvr8hcW5FZF3Of0Vbvs4=";
  };

  postPatch = ''
    # Upstream doesn't set a version in the pyproject.toml file
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${finalAttrs.version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    pillow
    vacuum-map-parser-base
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "vacuum_map_parser_roidmi"
    "vacuum_map_parser_roidmi.map_data_parser"
  ];

  meta = {
    description = "Functionalities for Roidmi vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roidmi";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roidmi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
