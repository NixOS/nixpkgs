{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  spacy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spacy-lookups-data";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "spacy-lookups-data";
    rev = "refs/tags/v${version}";
    hash = "sha256-6sKZ+GgCjLWYnV96nub4xEUFh1qpPQpbnoxyOVrvcD0=";
  };

  nativeCheckInputs = [
    spacy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "spacy_lookups_data" ];

  meta = with lib; {
    description = "Additional lookup tables and data resources for spaCy";
    homepage = "https://pypi.org/project/spacy-lookups-data";
    license = licenses.mit;
    maintainers = with maintainers; [ jboy ];
  };
}
