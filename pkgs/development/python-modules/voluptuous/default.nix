{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.15.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "voluptuous";
    rev = "refs/tags/${version}";
    hash = "sha256-TGTdYme3ZRM51YFNX/ESFc6+3QpeO/gAXYW6MT73/Ss=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "voluptuous" ];

  pytestFlagsArray = [ "voluptuous/tests/" ];

  meta = with lib; {
    description = "Python data validation library";
    downloadPage = "https://github.com/alecthomas/voluptuous";
    homepage = "http://alecthomas.github.io/voluptuous/";
    changelog = "https://github.com/alecthomas/voluptuous/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
