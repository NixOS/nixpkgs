{ lib, buildPythonApplication, fetchPypi, i3ipc, importlib-metadata }:

buildPythonApplication rec {
  pname = "autotiling";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hwvy9bxwv9fakqqiyrkmpckxgm0z85c240p84ibdhja9sm086v0";
  };

  propagatedBuildInputs = [ i3ipc importlib-metadata ];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/autotiling";
    description = "Script for sway and i3 to automatically switch the horizontal / vertical window split orientation";
    license = licenses.gpl3Plus;
    platforms= platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}

