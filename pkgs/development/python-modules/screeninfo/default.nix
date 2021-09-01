{ lib
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
  version = "0.7";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12a97c3527e3544ac5dbd7c1204283e2653d655cbd15844c990a83b1b13ef500";
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
    description = "Fetch location and size of physical screens";
    homepage = "https://github.com/rr-/screeninfo";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
