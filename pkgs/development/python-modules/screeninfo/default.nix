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

  postPatch = ''
    substituteInPlace screeninfo/enumerators/xinerama.py \
      --replace 'load_library("X11")' 'ctypes.cdll.LoadLibrary("${libX11}/lib/libX11.so")' \
      --replace 'load_library("Xinerama")' 'ctypes.cdll.LoadLibrary("${libXinerama}/lib/libXinerama.so")'
    substituteInPlace screeninfo/enumerators/xrandr.py \
      --replace 'load_library("X11")' 'ctypes.cdll.LoadLibrary("${libX11}/lib/libX11.so")' \
      --replace 'load_library("Xrandr")' 'ctypes.cdll.LoadLibrary("${libXrandr}/lib/libXrandr.so")'
  '';

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
