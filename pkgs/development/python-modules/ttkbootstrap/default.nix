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
  version = "1.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "israel-dryer";
    repo = "ttkbootstrap";
    tag = "v${version}";
    hash = "sha256-7LI/kfDpM7yv8jx8RTwz/VjK5WXHKKfKM+RK4ubALjc=";
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
