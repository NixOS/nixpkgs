{
  lib,
  buildPythonPackage,
  colorama,
  docstring-parser,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "targ";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "piccolo-orm";
    repo = "targ";
    tag = version;
    hash = "sha256-myQe8Gpnx5CqKnYNK0PZ2P7o+eVWKLInjyTaZd30WxU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    docstring-parser
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "targ" ];

  meta = {
    description = "Python CLI using type hints and docstrings";
    homepage = "https://github.com/piccolo-orm/targ/";
    changelog = "https://github.com/piccolo-orm/targ/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
