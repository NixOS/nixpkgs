{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, attrs
, pdfminer
, commoncode
, plugincode
, binaryornot
, typecode-libmagic
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "typecode";
  version = "21.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3a82859df5607c900972e08e1bca31e3fe2daed37afd1b8231cad2ef613d8d6";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    pdfminer
    commoncode
    plugincode
    binaryornot
    typecode-libmagic
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  disabledTests = [
    "TestFileTypesDataDriven"
    # AssertionError: assert 'application/x-bytecode.python'...
    "test_compiled_python_1"
  ];

  pythonImportsCheck = [
    "typecode"
  ];

  meta = with lib; {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/nexB/typecode";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
