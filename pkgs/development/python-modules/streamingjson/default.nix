{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "streamingjson";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "karminski";
    repo = "streaming-json-py";
    tag = version;
    hash = "sha256-XKqW5gbK55OKoAWftoh5CmGc0Sn5FOvGKmrAbsEvIMo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "streamingjson" ];

  meta = {
    description = "Streamlined, user-friendly JSON streaming preprocessor";
    homepage = "https://github.com/karminski/streaming-json-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethanthoma ];
  };
}
