{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  setuptools,
  libusb1,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libusb1";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vpelletier";
    repo = "python-libusb1";
    tag = version;
    hash = "sha256-w+Q00GWNobqQlvqryZlJl7SZPEMYgMtbuKpUSLneqNw=";
  };

  patches = [
    (replaceVars ./ctypes.patch {
      libusb = "${lib.getLib libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  buildInputs = [ libusb1 ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "usb1/testUSB1.py" ];

  meta = {
    homepage = "https://github.com/vpelletier/python-libusb1";
    description = "Python ctype-based wrapper around libusb1";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      prusnak
      rnhmjoj
    ];
  };
}
