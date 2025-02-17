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
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UP9nHLHGYNZm5eXHfNufDYhd9pPvrmp3HcVUFAjcAZw=";
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
