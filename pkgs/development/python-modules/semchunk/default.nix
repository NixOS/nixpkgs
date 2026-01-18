{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mpire,
  tqdm,
}:

buildPythonPackage rec {
  pname = "semchunk";
  version = "3.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "isaacus-dev";
    repo = "semchunk";
    tag = "v${version}";
    hash = "sha256-LUMpERJ8bZkpRn0Tay0BoDXmRgPaV7z0LulpTILHgjk=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mpire
    tqdm
  ];

  pythonImportsCheck = [
    "semchunk"
  ];

  meta = {
    description = "Fast, lightweight and easy-to-use Python library for splitting text into semantically meaningful chunks";
    changelog = "https://github.com/isaacus-dev/semchunk/releases/tag/v${version}";
    homepage = "https://github.com/isaacus-dev/semchunk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
