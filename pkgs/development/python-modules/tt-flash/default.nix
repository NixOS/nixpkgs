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
  version = "4.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-flash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ImAI+A229NzNECu3dL6WvsPO0cn8Id/p8/QqyvZ/H8=";
  };

  pythonRelaxDeps = [
    "pyyaml"
    "tabulate"
    "pyluwen"
  ];

  build-system = [ setuptools ];

  dependencies = [
    tabulate
    pyyaml
    pyluwen
    tt-tools-common
  ];

  pythonImportsCheck = [ "tt_flash" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Tenstorrent Firmware Update Utility";
    homepage = "https://tenstorrent.com";
    downloadPage = "https://github.com/tenstorrent/tt-flash";
    changelog = "https://github.com/tenstorrent/tt-flash/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
  };
})
