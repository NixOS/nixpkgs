{ lib
, buildPythonPackage
, fetchFromGitHub
, colorama
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "simber";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    hash = "sha256-P4bhxu9Di4E2Zkd0vIkyDi1S6Y0V/EQSMF4ftWoiXKE=";
  };

  propagatedBuildInputs = [
    colorama
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "simber"
  ];

  meta = with lib; {
    description = "Simple, minimal and powerful logger for Python";
    homepage = "https://github.com/deepjyoti30/simber";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
