{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libx11,
  libxinerama,
  libxrandr,
  poetry-core,
  pyobjc-framework-Cocoa,
  cython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "screeninfo";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "screeninfo";
    tag = version;
    hash = "sha256-TEy4wff0eRRkX98yK9054d33Tm6G6qWrd9Iv+ITcFmA=";
  };

  build-system = [ poetry-core ];

  dependencies = lib.optionals (stdenv.isDarwin) [
    pyobjc-framework-Cocoa
    cython
  ];

  postPatch = lib.optionalString (stdenv.isLinux) ''
    substituteInPlace screeninfo/enumerators/xinerama.py \
      --replace 'load_library("X11")' 'ctypes.cdll.LoadLibrary("${libx11}/lib/libX11.so")' \
      --replace 'load_library("Xinerama")' 'ctypes.cdll.LoadLibrary("${libxinerama}/lib/libXinerama.so")'
    substituteInPlace screeninfo/enumerators/xrandr.py \
      --replace 'load_library("X11")' 'ctypes.cdll.LoadLibrary("${libx11}/lib/libX11.so")' \
      --replace 'load_library("Xrandr")' 'ctypes.cdll.LoadLibrary("${libxrandr}/lib/libXrandr.so")'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # We don't have a screen
    "tests/test_screeninfo.py"
  ];

  pythonImportsCheck = [ "screeninfo" ];

  meta = {
    description = "Fetch location and size of physical screens";
    homepage = "https://github.com/rr-/screeninfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickhu ];
  };
}
