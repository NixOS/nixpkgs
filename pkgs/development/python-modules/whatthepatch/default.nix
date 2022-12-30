{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whatthepatch";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "cscorley";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-P4SYSMdDjwXOmre3hXKS4gQ0OS9pz0SWqBeD/WQMQFw=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "whatthepatch" ];

  meta = with lib; {
    description = "Python library for both parsing and applying patch files";
    homepage = "https://github.com/cscorley/whatthepatch";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
