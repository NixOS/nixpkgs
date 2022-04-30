{ lib, buildPythonApplication, fetchFromGitHub, i3ipc, importlib-metadata }:

buildPythonApplication rec {
  pname = "autotiling";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hjlvg7095s322gb43r9g7mqlsy3pj13l827jpnbn5x0918rq9rr";
  };

  propagatedBuildInputs = [ i3ipc importlib-metadata ];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/autotiling";
    description = "Script for sway and i3 to automatically switch the horizontal / vertical window split orientation";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}

