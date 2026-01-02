{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  i3ipc,
  importlib-metadata,
}:

buildPythonApplication rec {
  pname = "autotiling";
  version = "1.9.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "autotiling";
    tag = "v${version}";
    hash = "sha256-k+UiAGMB/fJiE+C737yGdyTpER1ciZrMkZezkcn/4yk=";
  };

  propagatedBuildInputs = [
    i3ipc
    importlib-metadata
  ];
  doCheck = false;

  meta = {
    homepage = "https://github.com/nwg-piotr/autotiling";
    description = "Script for sway and i3 to automatically switch the horizontal / vertical window split orientation";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ artturin ];
    mainProgram = "autotiling";
  };
}
