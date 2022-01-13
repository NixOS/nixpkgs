{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "unicodedata2";
  version = "14.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mikekap";
    repo = pname;
    rev = version;
    sha256 = "sha256-pNnsRVVO03vkDiFIh7x0M7+PULaPZCzJ9OKlidsIKO0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "unicodedata2"
  ];

  meta = with lib; {
    description = "Backport and updates for the unicodedata module";
    homepage = "https://github.com/mikekap/unicodedata2";
    license = licenses.asl20;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
