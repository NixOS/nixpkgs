{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, attrs
, pdfminer-six
, commoncode
, plugincode
, binaryornot
, typecode-libmagic
, pytestCheckHook
, pytest-xdist
, pythonOlder
}:

buildPythonPackage rec {
  pname = "typecode";
  version = "30.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Glc5QiTVr//euymeNTxGN+FVaOEa6cUxHGyGo9bQrJc=";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
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
    # https://github.com/nexB/typecode/issues/36

    # AssertionError: assert 'application/x-bytecode.python'...
    "test_compiled_python_1"
    "test_package_json"

    # fails due to change in file (libmagic) 5.45
    "test_doc_postscript_eps"
    "test_package_debian"
  ];

  pythonImportsCheck = [
    "typecode"
  ];

  meta = with lib; {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/nexB/typecode";
    changelog = "https://github.com/nexB/typecode/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
