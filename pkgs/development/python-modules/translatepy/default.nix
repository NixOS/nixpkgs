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
  version = "2.1";

  src = fetchFromGitHub {
    owner = "Animenosekai";
    repo = "translate";
    rev = "v${version}";
    sha256 = "0xj97s6zglvq2894wpq3xbjxgfkrfk2414vmcszap8h9j2zxz8gf";
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
    "tests/test_translators.py"
  ];
  pythonImportsCheck = [ "translatepy" ];

  meta = with lib; {
    description = "A module grouping multiple translation APIs";
    homepage = "https://github.com/Animenosekai/translate";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ angustrau ];
  };
}
