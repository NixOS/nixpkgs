{
  buildPythonPackage,
  attrs,
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
  pyproject = false;

  srcs = textx.testout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    attrs
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

  enabledTestPaths = [ "tests/functional" ];
  disabledTests = [
    "test_examples" # assertion error: 0 == 12
  ];

  meta = {
    inherit (textx.meta) license maintainers;
    description = "passthru.tests for textx";
    homepage = textx.homepage + "tree/${textx.version}/" + "tests/";
  };
}
