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
  pname = "vacuum-map-parser-viomi";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${pname}";
    tag = "v${version}";
    hash = "sha256-ritPucFznZvqgvCmp2RJ6SoGJko6LHL74ecSDhu7JG0=";
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

  pythonImportsCheck = [ "vacuum_map_parser_viomi" ];

  meta = {
    description = "Functionalities for Viomi vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-viomi";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-viomi/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ dady8889 ];
    license = lib.licenses.asl20;
  };
}
