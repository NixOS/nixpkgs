{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pyyaml,
  tabulate,
  pyluwen,
  tt-tools-common,

  # tests
  pytestCheckHook,
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

  pythonRelaxDeps = [
    "pyyaml"
    "tabulate"
  ];
  dependencies = [
    tabulate
    pyyaml
    pyluwen
    tt-tools-common
  ];

  pythonImportsCheck = [ "tt_flash" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Tenstorrent Firmware Update Utility";
    homepage = "https://tenstorrent.com";
    downloadPage = "https://github.com/tenstorrent/tt-flash";
    changelog = "https://github.com/tenstorrent/tt-flash/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
})
