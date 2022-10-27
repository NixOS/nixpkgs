{ lib, buildPythonApplication, fetchFromGitHub, i3ipc, importlib-metadata }:

buildPythonApplication rec {
  pname = "autotiling";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-2zWuATgj92s3tPqvB4INPfucmJTWYmGBx12U10qXohw=";
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

