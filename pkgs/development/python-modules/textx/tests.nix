{
  lib,
  buildPythonPackage,
  click,
  gprof2dot,
  html5lib,
  jinja2,
  memory-profiler,
  psutil,
  pytestCheckHook,
  setuptools,
  textx,
  textx-data-dsl,
  textx-example-project,
  textx-flow-codegen,
  textx-flow-dsl,
  textx-types-dsl,
}:

buildPythonPackage {
  pname = "textx-tests";
  inherit (textx) version;

  srcs = textx.testout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    click
    gprof2dot
    html5lib
    jinja2
    memory-profiler
    psutil
    pytestCheckHook
    setuptools
    textx-data-dsl
    textx-example-project
    textx-flow-codegen
    textx-flow-dsl
    textx-types-dsl
  ];

  pytestFlagsArray = [ "tests/functional" ];

  meta = with lib; {
    inherit (textx.meta) license maintainers;
    description = "passthru.tests for textx";
    homepage = textx.homepage + "tree/${version}/" + "tests/";
  };
}
