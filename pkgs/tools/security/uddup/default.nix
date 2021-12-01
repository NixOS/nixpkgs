{ lib
, buildPythonApplication
, colorama
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "uddup";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "rotemreiss";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f5dm3772hiik9irnyvbs7wygcafbwi7czw3b47cwhb90b8fi5hg";
  };

  propagatedBuildInputs = [
    colorama
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "uddup" ];

  meta = with lib; {
    description = "Tool for de-duplication URLs";
    homepage = "https://github.com/rotemreiss/uddup";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
