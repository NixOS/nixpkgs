{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pillow,
  pycryptodome,
  pyprojectVersionPatchHook,
  vacuum-map-parser-base,
}:

buildPythonPackage (finalAttrs: {
  pname = "vacuum-map-parser-dreame";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-vacuum-map-parser-dreame";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ZuyRK5KKlul+VycH6lQFRJVKCT4AUFXjeY+t4sHqtk=";
  };

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    pillow
    pycryptodome
    vacuum-map-parser-base
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "vacuum_map_parser_dreame"
    "vacuum_map_parser_dreame.map_data_parser"
  ];

  meta = {
    description = "Functionalities for Dreame vacuum map parsing";
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-dreame";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-dreame/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
