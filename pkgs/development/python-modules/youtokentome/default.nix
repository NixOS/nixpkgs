{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, click
, cython
, pytestCheckHook
, pythonOlder
, tabulate
}:

buildPythonPackage rec {
  pname = "youtokentome";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "VKCOM";
    repo = "YouTokenToMe";
    rev = "refs/tags/v${version}";
    hash = "sha256-IFZS4jSi4yMzI7VbOPHI3KFZu5tjPjfQDPY7e1qbKAM=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    click
    tabulate
  ];

  pythonImportsCheck = [
    "youtokentome"
  ];

  meta = with lib; {
    description = "Unsupervised text tokenizer";
    homepage = "https://github.com/VKCOM/YouTokenToMe";
    changelog = "https://github.com/VKCOM/YouTokenToMe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
