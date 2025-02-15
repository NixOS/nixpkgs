{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pillow,
  setuptools,
  tkinter,
  wheel,
}:

buildPythonPackage rec {
  pname = "ttkbootstrap";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "israel-dryer";
    repo = "ttkbootstrap";
    rev = "v${version}";
    hash = "sha256-aUqr30Tgz3ZLjLbNIt9yi6bqhXj+31heZoOLOZHYUiU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    pillow
    tkinter
  ];

  pythonImportsCheck = [ "ttkbootstrap" ];

  meta = {
    description = "Supercharged theme extension for tkinter that enables on-demand modern flat style themes inspired by Bootstrap";
    homepage = "https://github.com/israel-dryer/ttkbootstrap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
