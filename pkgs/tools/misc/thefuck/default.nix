{ lib, fetchFromGitHub, buildPythonApplication
, colorama, decorator, psutil, pyte, six
, go, mock, pytestCheckHook, pytest-mock
}:

buildPythonApplication rec {
  pname = "thefuck";
  version = "3.31";

  src = fetchFromGitHub {
    owner = "nvbn";
    repo = pname;
    rev = version;
    sha256 = "sha256-eKKUUJr00sUtT4u91MUgJjyPOXp3NigYVfYUP/sDBhY=";
  };

  propagatedBuildInputs = [ colorama decorator psutil pyte six ];

  checkInputs = [ go mock pytestCheckHook pytest-mock ];

  meta = with lib; {
    homepage = "https://github.com/nvbn/thefuck";
    description = "Magnificent app which corrects your previous console command";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
