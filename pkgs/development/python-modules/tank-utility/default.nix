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
    rev = version;
    hash = "sha256-h9y3X+FSzSFt+bd/chz+x0nocHaKZ8DvreMxAYMs8/E=";
  };

  postPatch = ''
    # urllib3[secure] is not picked-up
    substituteInPlace setup.py \
      --replace "urllib3[secure]" "urllib3"
  '';

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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
