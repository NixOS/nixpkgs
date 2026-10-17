{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  wheel,

  # dependencies
  matplotlib,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "tt-perf-report";
  version = "1.4.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-perf-report";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gAA18qG+pTj24BFZ51ojxI5c84c6z0ceuQ4YzmC681w=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    matplotlib
    pandas
  ];

  pythonRelaxDeps = [ "matplotlib" ];

  pythonImportsCheck = [ "tt_perf_report" ];

  meta = {
    description = "Tool for analyzing performance traces from Metal operations";
    homepage = "https://github.com/tenstorrent/tt-perf-report";
    changelog = "https://github.com/tenstorrent/tt-perf-report/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mert-kurttutan ];
    mainProgram = "tt-perf-report";
  };
})
