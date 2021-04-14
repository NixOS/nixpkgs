{ lib
, fetchFromGitHub
, buildPythonPackage
, pyusb
, numpy
}:

## Usage
# In NixOS, add the package to services.udev.packages for non-root plugdev
# users to get device access permission:
#    services.udev.packages = [ pkgs.python3Packages.seabreeze ];

buildPythonPackage rec {
  pname = "seabreeze";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ap--";
    repo = "python-seabreeze";
    rev = "v${version}";
    sha256 = "1lna3w1vsci35dhyi7qjvbb99gxvzk23k195c7by7kkrps844q1j";
  };

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp misc/10-oceanoptics.rules $out/etc/udev/rules.d/10-oceanoptics.rules
  '';

  # underlying c libraries are tested and fail
  # (c libs are used with anaconda, which we don't care about as we use the alternative path, being that of pyusb).
  doCheck = false;

  propagatedBuildInputs = [ pyusb numpy ];

  setupPyBuildFlags = [ "--without-cseabreeze" ];

  meta = with lib; {
    homepage = "https://github.com/ap--/python-seabreeze";
    description = "A python library to access Ocean Optics spectrometers";
    maintainers = [];
    license = licenses.mit;
  };
}
