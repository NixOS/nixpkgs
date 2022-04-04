{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, beautifulsoup4
, pyuseragents
, inquirer
, safeio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "translatepy";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "Animenosekai";
    repo = "translate";
    rev = "v${version}";
    sha256 = "cx5OeBrB8il8KrcyOmQbQ7VCXoaA5RP++oTTxCs/PcM=";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
    pyuseragents
    inquirer
    safeio
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
