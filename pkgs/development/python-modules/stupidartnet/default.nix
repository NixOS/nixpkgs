{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stupidartnet";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cpvalente";
    repo = "stupidArtnet";
    rev = "refs/tags/${version}";
    hash = "sha256-6vEzInt1ofVVjTZAOH0Zw3BdwpX//1ZWwJqWPP5fIC8=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stupidArtnet" ];

  meta = with lib; {
    description = "Library implementation of the Art-Net protocol";
    homepage = "https://github.com/cpvalente/stupidArtnet";
    changelog = "https://github.com/cpvalente/stupidArtnet/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
