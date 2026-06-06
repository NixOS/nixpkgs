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
buildPythonPackage (finalAttrs: {
  pname = "tt-flash";
  version = "3.8.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-flash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p1NzR53n9f4nVQXHDxTlbtqYVTL/5/ZSqkM3ldozsME=";
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
  pythonRelaxDeps = [
    "pyyaml"
    "tabulate"
  ];

  meta = {
    description = "Tenstorrent Firmware Update Utility";
    homepage = "https://tenstorrent.com";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
})
