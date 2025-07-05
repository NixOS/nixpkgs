{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  hatchling,
  httpx,
  tomli,
}:

buildPythonPackage rec {
  pname = "wn";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TDvTNh+5cxgBoy9nuXItHOdtfbsP+3F16egZjUBSpak=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
    tomli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "wn" ];

  meta = with lib; {
    description = "Modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
