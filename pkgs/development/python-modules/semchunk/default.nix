{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  mpire,
  tqdm,
}:

buildPythonPackage rec {
  pname = "semchunk";
  version = "3.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PKFv8EFHdRE2VEnd88h+LOhKrv8p9X5sH9kKawXqdsY=";
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
    description = "A fast, lightweight and easy-to-use Python library for splitting text into semantically meaningful chunks";
    homepage = "https://pypi.org/project/semchunk/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
