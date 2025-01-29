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
  pname = "vacuum-map-parser-roborock";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${pname}";
    rev = "refs/tags/v${version}";
    hash = "sha256-y7Q8C7ZvOn/KSUMJ7A/oH+HZMVBpuPitsXqsqHvvYHE=";
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

  meta = with lib; {
    description = "Functionalities for Roborock vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roborock";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-roborock/releases/tag/v${version}";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.asl20;
  };
}
