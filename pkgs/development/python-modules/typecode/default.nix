{
  lib,
  fetchPypi,
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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "typecode";
  version = "30.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F2idIK8K5hFueX7yxd5l8M6AkSjPDmhHmzS9a6S8OJg=";
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
    "test_compiled_python_1"
    "test_package_json"

    # fails due to change in file (libmagic) 5.45
    "test_doc_postscript_eps"
    "test_package_debian"
  ];

  pythonImportsCheck = [ "typecode" ];

  meta = with lib; {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/aboutcode-org/typecode";
    changelog = "https://github.com/aboutcode-org/typecode/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
