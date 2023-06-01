{ lib, buildPythonApplication, fetchFromGitHub, i3ipc, importlib-metadata }:

buildPythonApplication rec {
  pname = "autotiling";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4iiiiuXCHFXEeA99ikq/G3q2KXBZ7vwpfET7QtoDVds=";
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

