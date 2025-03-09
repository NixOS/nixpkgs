{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libX11,
  libXinerama,
  libXrandr,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "screeninfo";
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rr-";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-TEy4wff0eRRkX98yK9054d33Tm6G6qWrd9Iv+ITcFmA=";
  };

  nativeBuildInputs = [ poetry-core ];

  postPatch = ''
    substituteInPlace screeninfo/enumerators/xinerama.py \
      --replace 'load_library("X11")' 'ctypes.cdll.LoadLibrary("${libX11}/lib/libX11.so")' \
      --replace 'load_library("Xinerama")' 'ctypes.cdll.LoadLibrary("${libXinerama}/lib/libXinerama.so")'
    substituteInPlace screeninfo/enumerators/xrandr.py \
      --replace 'load_library("X11")' 'ctypes.cdll.LoadLibrary("${libX11}/lib/libX11.so")' \
      --replace 'load_library("Xrandr")' 'ctypes.cdll.LoadLibrary("${libXrandr}/lib/libXrandr.so")'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # We don't have a screen
    "tests/test_screeninfo.py"
  ];

  pythonImportsCheck = [ "screeninfo" ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Fetch location and size of physical screens";
    homepage = "https://github.com/rr-/screeninfo";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
  };
}
