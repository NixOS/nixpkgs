{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "treelib";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "caesar0301";
    repo = "treelib";
    tag = "v${version}";
    hash = "sha256-jvaZVy+FUcCcIdvWK6zFL8IBVH+hMiPMmv5shFXLo0k=";
  };

  build-system = [ poetry-core ];

  dependencies = [ six ];

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
