{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  httpx,
  tomli,

  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "wn";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "goodmami";
    repo = "wn";
    tag = "v${version}";
    hash = "sha256-pGDYXuvDTjdAD01wv+LdiFkGFm2JPGI1Rk8RWzd6kS8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
    tomli
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wn" ];

  meta = with lib; {
    description = "Modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
