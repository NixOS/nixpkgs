{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "tank-utility";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "krismolendyke";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-h9y3X+FSzSFt+bd/chz+x0nocHaKZ8DvreMxAYMs8/E=";
  };

  propagatedBuildInputs = [
    requests
    urllib3
    setuptools
  ] ++ urllib3.optional-dependencies.secure;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "tank_utility"
  ];

  meta = with lib; {
    description = "Library for the Tank Utility API";
    homepage = "https://github.com/krismolendyke/tank-utility";
    changelog = "https://github.com/krismolendyke/tank-utility/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
