{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pillow,
  vacuum-map-parser-base,
}:

buildPythonPackage rec {
  pname = "vacuum-map-parser-roborock";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${pname}";
    tag = "v${version}";
    hash = "sha256-MqsLvAs4PU/K2yBxEhVJucstZg9QFPYgOTCbgT2Uq/A=";
  };

  postPatch = ''
    # Upstream doesn't set a version in the pyproject.toml file
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    pillow
    vacuum-map-parser-base
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "vacuum_map_parser_roborock" ];

  meta = {
    description = "Functionalities for Roborock vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roborock";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roborock/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.asl20;
  };
}
