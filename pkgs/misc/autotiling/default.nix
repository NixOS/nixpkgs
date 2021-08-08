{ lib, buildPythonApplication, fetchFromGitHub, i3ipc, importlib-metadata }:

buildPythonApplication rec {
  pname = "autotiling";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ih8yd1gankjxn88gd88vxs6f1cniyi04z25jz4nsgqi9snz65v4";
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

