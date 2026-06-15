{
  lib,
  attrdict,
  buildPythonPackage,
  cairosvg,
  fetchPypi,
  setuptools,
  pillow,
  pytestCheckHook,
  pyyaml,
  setuptools-scm,
  six,
  svgwrite,
  xmldiff,
}:

buildPythonPackage (finalAttrs: {
  pname = "wavedrom";
  version = "2.0.3.post3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-MntNXcpZPIElfCAv6lFvepCHR/sRUnw1nwNPW3r39Hs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrdict
    pyyaml
    svgwrite
    six
  ];

  nativeCheckInputs = [
    cairosvg
    pillow
    pytestCheckHook
    xmldiff
  ];

  disabledTests = [
    # Requires to clone a full git repository
    "test_upstream"
  ];

  pythonImportsCheck = [ "wavedrom" ];

  meta = {
    description = "WaveDrom compatible Python command line";
    mainProgram = "wavedrompy";
    homepage = "https://github.com/wallento/wavedrompy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airwoodix ];
  };
})
