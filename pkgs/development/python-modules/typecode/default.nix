{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  attrs,
  pdfminer-six,
  commoncode,
  plugincode,
  binaryornot,
  typecode-libmagic,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "typecode";
  version = "30.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "typecode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+7Yu2t++4PaF8yT+kKgo5MP6lbr8CXkjo5/4KMrApZY=";
  };

  dontConfigure = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    pdfminer-six
    commoncode
    plugincode
    binaryornot
    typecode-libmagic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    "TestFileTypesDataDriven"

    # Many of the failures below are reported in:
    # https://github.com/aboutcode-org/typecode/issues/36

    # AssertionError: assert 'application/x-bytecode.python'...
    "test_package_json"

    # fails due to change in file (libmagic) 5.45
    "test_doc_postscript_eps"
    "test_package_debian"
  ];

  pythonImportsCheck = [ "typecode" ];

  meta = {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/aboutcode-org/typecode";
    changelog = "https://github.com/aboutcode-org/typecode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
