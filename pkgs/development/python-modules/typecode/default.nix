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
  version = "30.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pRGLU/xzQQqDZMIsrq1Fy7VgGIpFjnHtpmO+yL7t4g8=";
  };

  postPatch = ''
    # PEP440 support was removed in newer setuptools, https://github.com/nexB/typecode/pull/31
    substituteInPlace setup.cfg \
      --replace ">=3.6.*" ">=3.6"
  '';

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
    # AssertionError: assert 'application/x-bytecode.python'...
    "test_compiled_python_1"
    "test_package_json"
  ];

  pythonImportsCheck = [
    "typecode"
  ];

  meta = with lib; {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/nexB/typecode";
    changelog = "https://github.com/nexB/typecode/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
