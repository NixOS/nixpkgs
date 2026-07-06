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
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-flash";
    tag = "v${version}";
    hash = "sha256-io3+fNQWS1Gxb0L0HcQQocOT+ROjQUk4mw7xG3om7oU=";
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
