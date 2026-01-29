{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "streamingjson";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karminski";
    repo = "streaming-json-py";
    rev = version;
    hash = "sha256-XKqW5gbK55OKoAWftoh5CmGc0Sn5FOvGKmrAbsEvIMo=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "streamingjson"
  ];

  meta = {
    description = "A streamlined, user-friendly JSON streaming preprocessor, crafted in Python";
    homepage = "https://github.com/karminski/streaming-json-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jinser ];
  };
}
