{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "treelib";
  version = "1.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "caesar0301";
    repo = "treelib";
    tag = "v${version}";
    hash = "sha256-+6Ur2hEhUxHccZLdWHCyCkdI6Zr/wGTBIIzzbpEEiSY=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "treelib" ];

  meta = with lib; {
    description = "Efficient implementation of tree data structure in python 2/3";
    homepage = "https://github.com/caesar0301/treelib";
    changelog = "https://github.com/caesar0301/treelib/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
