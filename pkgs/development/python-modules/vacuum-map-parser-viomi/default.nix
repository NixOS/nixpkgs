{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pillow,
  vacuum-map-parser-base,
}:

buildPythonPackage (finalAttrs: {
  pname = "vacuum-map-parser-viomi";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-vacuum-map-parser-viomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ritPucFznZvqgvCmp2RJ6SoGJko6LHL74ecSDhu7JG0=";
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
    "vacuum_map_parser_viomi"
    "vacuum_map_parser_viomi.map_data_parser"
  ];

  meta = {
    description = "Functionalities for Viomi vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-viomi";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-viomi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
