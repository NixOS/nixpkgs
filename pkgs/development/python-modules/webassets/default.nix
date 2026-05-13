{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
  jinja2,
  mock,
  pytestCheckHook,
  distutils,
  zope-dottedname,
}:

buildPythonPackage rec {
  pname = "webassets";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BSDl/W+8wBL0hv78YblmR02o/Bs1sFaansLLB4LxYHo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    zope-dottedname
  ];

  nativeCheckInputs = [
    jinja2
    mock
    pytestCheckHook
    distutils
  ];

  disabledTests = [
    "TestFilterBaseClass"
    "TestAutoprefixer6Filter"
    "TestBabel"
  ];

  meta = {
    description = "Media asset management for Python, with glue code for various web frameworks";
    mainProgram = "webassets";
    homepage = "https://github.com/miracle2k/webassets/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
