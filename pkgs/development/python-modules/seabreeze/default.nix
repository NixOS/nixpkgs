{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  cython,
  git,
  pkgconfig,
  setuptools,
  setuptools-scm,

  # dependneices
  numpy,
  libusb-compat-0_1,

  # optional-dependenices
  pyusb,

  # tests
  mock,
  pytestCheckHook,
  zipp,
}:

## Usage
# In NixOS, add the package to services.udev.packages for non-root plugdev
# users to get device access permission:
#    services.udev.packages = [ pkgs.python3Packages.seabreeze ];

buildPythonPackage rec {
  pname = "seabreeze";
  version = "2.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ap--";
    repo = "python-seabreeze";
    rev = "refs/tags/v${version}";
    hash = "sha256-NzZ+ZRfJ97Ufp6hmqN6ziBFfdvJXpmWwh9A66od/8Hc=";
    leaveDotGit = true;
  };

  enableParallelBuilding = true;

  postPatch = ''
    # pkgconfig cant find libusb, doing it manually
    substituteInPlace setup.py \
      --replace-fail 'pkgconfig.parse("libusb")' \
        "{'include_dirs': ['${libusb-compat-0_1}/include'], 'library_dirs': ['${libusb-compat-0_1}/lib'], 'libraries': ['usb']}"
  '';

  nativeBuildInputs = [
    cython
    git
    pkgconfig
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    libusb-compat-0_1
  ];

  optional-dependencies = {
    pyseabreeze = [ pyusb ];
  };

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp os_support/10-oceanoptics.rules $out/etc/udev/rules.d/10-oceanoptics.rules
  '';

  # few backends enabled, but still some tests
  nativeCheckInputs = [
    pytestCheckHook
    mock
    zipp
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [ "TestHardware" ];

  setupPyBuildFlags = [ "--without-cseabreeze" ];

  meta = with lib; {
    homepage = "https://github.com/ap--/python-seabreeze";
    description = "Python library to access Ocean Optics spectrometers";
    maintainers = [ ];
    license = licenses.mit;
  };
}
