{ stdenv
, lib
, buildPythonApplication
, dataclasses
, fetchPypi
, libX11
, libXinerama
, libXrandr
, pytestCheckHook
, pythonOlder
}:

buildPythonApplication rec {
  pname = "screeninfo";
  version = "0.8";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9501bf8b8458c7d1be4cb0ac9abddddfa80b932fb3f65bfcb54f5586434b1dc5";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [
    dataclasses
  ];

  buildInputs = [
    libX11
    libXinerama
    libXrandr
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # We don't have a screen
    "screeninfo/test_screeninfo.py"
  ];

  pythonImportsCheck = [ "screeninfo" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Fetch location and size of physical screens";
    homepage = "https://github.com/rr-/screeninfo";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
