{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  asteval,
  cachetools,
  click,
  moderngl,
  multiprocess,
  numpy,
  pnoise,
  pyphen,
  scipy,
  shapely,
  svgelements,
  svgwrite,
  tomli,
}:

buildPythonPackage (finalAttrs: {
  pname = "vpype";
  version = "1.15.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-CQofiMiII43wdE3gF5udnzgpzYi6xguISQ4+OXqErtM=";
  };

  pythonRelaxDeps = [ "pyphen" ];

  build-system = [ poetry-core ];

  dependencies = [
    asteval
    cachetools
    click
    moderngl
    multiprocess
    numpy
    pnoise
    pyphen
    scipy
    shapely
    svgelements
    svgwrite
    tomli
  ];

  meta = {
    changelog = "https://github.com/abey79/vpype/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Swiss-Army-knife command-line/libary tool for plotter vector graphics";
    homepage = "https://github.com/abey79/vpype";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kybe236 ];
  };
})
