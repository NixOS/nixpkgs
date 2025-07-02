{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "spacy-legacy";
  version = "3.0.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s31uDJtuHXyhz1vHFSq2SkxGcfWcha2vej/LhwNXp3Q=";
  };

  # nativeCheckInputs = [ pytestCheckHook spacy ];
  doCheck = false;

  pythonImportsCheck = [ "spacy_legacy" ];

  meta = with lib; {
    description = "Legacy registered functions for spaCy backwards compatibility";
    homepage = "https://github.com/explosion/spacy-legacy";
    changelog = "https://github.com/explosion/spacy-legacy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
