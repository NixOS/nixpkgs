{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pillow,
  vacuum-map-parser-base,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "vacuum-map-parser-dreame";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${pname}";
    tag = "v${version}";
    hash = "sha256-7ZuyRK5KKlul+VycH6lQFRJVKCT4AUFXjeY+t4sHqtk=";
  };

  postPatch = ''
    # Upstream doesn't set a version in the pyproject.toml file
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    pillow
    pycryptodome
    vacuum-map-parser-base
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "vacuum_map_parser_dreame" ];

  meta = {
    description = "Functionalities for Dreame vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-dreame";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-dreame/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ dady8889 ];
    license = lib.licenses.asl20;
  };
}
