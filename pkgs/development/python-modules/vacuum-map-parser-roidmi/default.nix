{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pillow,
  vacuum-map-parser-base,
}:

buildPythonPackage rec {
  pname = "vacuum-map-parser-roidmi";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${pname}";
    tag = "v${version}";
    hash = "sha256-E4DCvDQRrdueGnKbY3D+Oh/hvr8hcW5FZF3Of0Vbvs4=";
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

  pythonImportsCheck = [ "vacuum_map_parser_roidmi" ];

  meta = {
    description = "Functionalities for Roidmi vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roidmi";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roidmi/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ dady8889 ];
    license = lib.licenses.asl20;
  };
}
