{ lib, fetchFromGitHub, buildPythonApplication
, colorama, decorator, psutil, pyte, six
, go, mock, pytestCheckHook, pytest-mock
}:

buildPythonApplication rec {
  pname = "thefuck";
  version = "3.30";

  src = fetchFromGitHub {
    owner = "nvbn";
    repo = pname;
    rev = version;
    sha256 = "0fnf78956pwhb9cgv1jmgypnkma5xzflkivfrkfiadbgin848yfg";
  };

  propagatedBuildInputs = [ colorama decorator psutil pyte six ];

  checkInputs = [ go mock pytestCheckHook pytest-mock ];

  meta = with lib; {
    homepage = "https://github.com/nvbn/thefuck";
    description = "Magnificent app which corrects your previous console command";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 SuperSandro2000 ];
  };
}
