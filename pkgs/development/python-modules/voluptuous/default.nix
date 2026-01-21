{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "voluptuous";
    tag = version;
    hash = "sha256-TGTdYme3ZRM51YFNX/ESFc6+3QpeO/gAXYW6MT73/Ss=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "voluptuous" ];

  enabledTestPaths = [ "voluptuous/tests/" ];

  meta = {
    description = "Python data validation library";
    downloadPage = "https://github.com/alecthomas/voluptuous";
    homepage = "http://alecthomas.github.io/voluptuous/";
    changelog = "https://github.com/alecthomas/voluptuous/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
