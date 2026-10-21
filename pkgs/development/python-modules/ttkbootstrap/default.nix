{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pillow,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ttkbootstrap";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "israel-dryer";
    repo = "ttkbootstrap";
    tag = "v${version}";
    hash = "sha256-SzPD8Z6J9sy7f2eB/mItf329/Wh+sESmhxDJ7v3CP1c=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pillow
  ];

  pythonRelaxDeps = [ "pillow" ];

  # As far as I can tell, all tests require a display and are not normal-ish pytests
  # but appear to just be python scripts that run demos of components?
  doCheck = false;

  meta = {
    description = "Supercharged theme extension for tkinter inspired by Bootstrap";
    homepage = "https://github.com/israel-dryer/ttkbootstrap";
    maintainers = with lib.maintainers; [ e1mo ];
    license = lib.licenses.mit;
  };
}
