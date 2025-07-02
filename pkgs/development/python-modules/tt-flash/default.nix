{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  pyyaml,
  tabulate,
  pyluwen,
  tt-tools-common,
}:
buildPythonPackage rec {
  pname = "tt-flash";
  version = "3.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-flash";
    tag = "v${version}";
    hash = "sha256-edWogH/HZZlGwyiqGbj6vunNxhsCr/+3LzmFgFGzjck=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    tabulate
    pyyaml
    pyluwen
    tt-tools-common
  ];

  pythonImportsCheck = [ "tt_flash" ];
  pythonRelaxDeps = [ "pyyaml" ];

  meta = {
    description = "Tenstorrent Firmware Update Utility";
    homepage = "https://tenstorrent.com";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
