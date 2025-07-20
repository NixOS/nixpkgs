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

  patches = [
    # Remove when https://github.com/tenstorrent/tt-flash/pull/41 is merged
    ./bump-pyyaml.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    tabulate
    pyyaml
    pyluwen
    tt-tools-common
  ];

  meta = {
    description = "Tenstorrent Firmware Update Utility";
    homepage = "https://github.com/tenstorrent/tt-flash";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
}
