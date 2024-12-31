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
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ap--";
    repo = "python-seabreeze";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ead9G4i8/mFwPqL2PGsndtmX93Njld3nvTTr6ROJTac=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    cython
    git
    pkgconfig
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ numpy ];

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  setupPyBuildFlags = [ "--without-cseabreeze" ];

  meta = with lib; {
    homepage = "https://github.com/ap--/python-seabreeze";
    description = "Python library to access Ocean Optics spectrometers";
    maintainers = [ ];
    license = licenses.mit;
  };
}
