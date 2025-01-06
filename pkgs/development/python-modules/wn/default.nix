{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  flit-core,
  requests,
  tomli,
}:

buildPythonPackage rec {
  pname = "wn";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-muYuDmYH9W5j6euDYJMMgzfsxE6eBIhDCqH6P7nFG+Q=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    requests
    tomli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "wn" ];

  meta = {
    description = "Modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
