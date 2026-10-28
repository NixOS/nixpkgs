{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  tqdm,
}:

buildPythonPackage rec {
  pname = "semchunk";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "isaacus-dev";
    repo = "semchunk";
    tag = "v${version}";
    hash = "sha256-jQQNb5E/EarsN9OwlF6l8huX06kM2EChfUYW+MM5uxA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
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
