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
<<<<<<< HEAD
  version = "30.0.1";
=======
  version = "30.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Glc5QiTVr//euymeNTxGN+FVaOEa6cUxHGyGo9bQrJc=";
  };

=======
    hash = "sha256-pRGLU/xzQQqDZMIsrq1Fy7VgGIpFjnHtpmO+yL7t4g8=";
  };

  postPatch = ''
    # PEP440 support was removed in newer setuptools, https://github.com/nexB/typecode/pull/31
    substituteInPlace setup.cfg \
      --replace ">=3.6.*" ">=3.6"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

    # Many of the failures below are reported in:
    # https://github.com/nexB/typecode/issues/36

    # AssertionError: assert 'application/x-bytecode.python'...
    "test_compiled_python_1"
    "test_package_json"

    # fails due to change in file (libmagic) 5.45
    "test_doc_postscript_eps"
    "test_package_debian"
=======
    # AssertionError: assert 'application/x-bytecode.python'...
    "test_compiled_python_1"
    "test_package_json"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "typecode"
  ];

  meta = with lib; {
    description = "Comprehensive filetype and mimetype detection using libmagic and Pygments";
    homepage = "https://github.com/nexB/typecode";
    changelog = "https://github.com/nexB/typecode/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
