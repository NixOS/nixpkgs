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
}:

buildPythonPackage rec {
  pname = "typecode";
  version = "30.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/KNhekPDB1eGVtcGNMKHx9oyruP97of7ydzx+9P7dQ8=";
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

    # fails due to change in file (libmagic) 5.46
    "test_media_image_img"
    "test_compiled_elf_so"
    "test_compiled_elf_so_2"
  ];

  pythonImportsCheck = [ "typecode" ];

  meta = {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/aboutcode-org/typecode";
    changelog = "https://github.com/aboutcode-org/typecode/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
