{
  lib,
  fetchFromGitHub,
  python3Packages,
  setuptools,
  buildPythonPackage,
  webcolors,
}:
buildPythonPackage rec {
  pname = "thumbor-plugins-gifv";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "thumbor";
    repo = "thumbor-plugins";
    tag = "thumbor-plugins-gifv-v${version}";
    hash = "sha256-P1EhAUTIyjAY5nXYoB7F67QqQHlxdz7JzRoPcRFN8f0=";
  };

  sourceRoot = "${src.name}/thumbor_plugins/optimizers/gifv";

  pyproject = true;

  build-system = [
    setuptools
  ];

  dependencies = [ webcolors ];

  pythonRelaxDeps = [ "webcolors" ];

  meta = {
    description = "Gifv plugin for Thumbor";
    homepage = "https://github.com/thumbor/thumbor-plugins/tree/master/thumbor_plugins/optimizers/gifv";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sephi ];
  };
}
