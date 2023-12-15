{ stdenv, lib, buildPythonPackage, fetchFromGitHub, libX11, libXinerama
, libXrandr, poetry-core, pytestCheckHook, pythonOlder, fetchpatch }:

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

  patches = lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url =
        "https://github.com/rr-/screeninfo/commit/26647c49000397236c0fbd023e90a6de80233d3a.patch";
      hash = "sha256-wTZK1H7qKujfzFT4SMGOGUpo5ueC+sHbMPQIDQ6X4C0=";
    })
    (fetchpatch {
      url =
        "https://github.com/rr-/screeninfo/commit/14de5bcae417fb85e3071bdaf2e7d2448a246a12.patch";
      hash = "sha256-7VRn7uzU9InwKzpYl99KHDV8hqyEeG69fwzdBgVrGH8=";
    })
    (fetchpatch {
      url =
        "https://github.com/rr-/screeninfo/commit/7de22e3fc4662586e13e87fbd65684efe0cca05e.patch";
      hash = "sha256-InbqJwAxP1TpAxlKx1cdumA5ozO6HHo5jNTb5tx78K8=";
    })
  ];

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
    description = "Fetch location and size of physical screens";
    homepage = "https://github.com/rr-/screeninfo";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu techknowlogick ];
  };
}
