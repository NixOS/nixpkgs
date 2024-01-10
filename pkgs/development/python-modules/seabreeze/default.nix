{ lib
, fetchFromGitHub
, buildPythonPackage
, cython
, git
, pkgconfig
, setuptools-scm
, future
, numpy
, pyusb
, mock
, pytestCheckHook
, zipp
}:

## Usage
# In NixOS, add the package to services.udev.packages for non-root plugdev
# users to get device access permission:
#    services.udev.packages = [ pkgs.python3Packages.seabreeze ];

buildPythonPackage rec {
  pname = "seabreeze";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ap--";
    repo = "python-seabreeze";
    rev = "v${version}";
    sha256 = "1hm9aalpb9sdp8s7ckn75xvyiacp5678pv9maybm5nz0z2h29ibq";
    leaveDotGit = true;
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  nativeBuildInputs = [
    cython
    git
    pkgconfig
    setuptools-scm
  ];

  propagatedBuildInputs = [
    future
    numpy
    pyusb
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp os_support/10-oceanoptics.rules $out/etc/udev/rules.d/10-oceanoptics.rules
  '';

  # few backends enabled, but still some tests
  nativeCheckInputs = [
    pytestCheckHook
    mock
    zipp
  ];

  setupPyBuildFlags = [ "--without-cseabreeze" ];

  meta = with lib; {
    homepage = "https://github.com/ap--/python-seabreeze";
    description = "A python library to access Ocean Optics spectrometers";
    maintainers = [];
    license = licenses.mit;
  };
}
