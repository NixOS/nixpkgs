{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.5.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xeBo3Ok+XPrHN4nQd7M8/11leSV/8z1f7Sj33+HFVtQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "shellingham"
  ];

  meta = with lib; {
    description = "Tool to detect the surrounding shell";
    homepage = "https://github.com/sarugaku/shellingham";
    changelog = "https://github.com/sarugaku/shellingham/blob/${version}/CHANGELOG.rst";
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
