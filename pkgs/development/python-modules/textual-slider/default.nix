{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  textual,
}:

buildPythonPackage {
  pname = "textual-slider";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "TomJGooding";
    repo = "textual-slider";
    rev = "91e64bafe3aa72f8d875e76b437d6af9320e039e";
    hash = "sha256-lwN7igiEB8uC9e7qBSVLuKCpF41+Ni7ZJ3cVK19cEY8=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [ textual ];

  meta = {
    description = "Textual widget for a simple slider";
    homepage = "https://github.com/TomJGooding/textual-slider";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.lukegb ];
  };
}
