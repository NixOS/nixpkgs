{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "treelib";
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "caesar0301";
    repo = "treelib";
    rev = "v${version}";
    hash = "sha256-FIdJWpkOmUVZb+IkYocu1nn+oSPROrkcHeiw9wZupgM=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "treelib" ];

  meta = with lib; {
    description = "An efficient implementation of tree data structure in python 2/3";
    homepage = "https://github.com/caesar0301/treelib";
    changelog = "https://github.com/caesar0301/treelib/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
