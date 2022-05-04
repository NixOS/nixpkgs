{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, beautifulsoup4
, pyuseragents
, inquirer
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "translatepy";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "Animenosekai";
    repo = "translate";
    rev = "v${version}";
    sha256 = "rnt4nmDgQXSgzwNCcsZwbQn2bv83DFhL86kebeiSosc=";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
    pyuseragents
    inquirer
  ];

  checkInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    # Requires network connection
    "tests/test_translate.py"
    "tests/test_translators.py"
  ];
  pythonImportsCheck = [ "translatepy" ];

  meta = with lib; {
    description = "A module grouping multiple translation APIs";
    homepage = "https://github.com/Animenosekai/translate";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ emilytrau ];
  };
}
