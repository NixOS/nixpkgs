{ stdenv
, fetchFromGitHub
, buildPythonPackage
, pyusb
, numpy
}:

## Usage
# In NixOS, simply add the `udev` multiple output to services.udev.packages:
#   services.udev.packages = [ pkgs.python3Packages.seabreeze.udev ];

buildPythonPackage rec {
  pname = "seabreeze";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ap--";
    repo = "python-seabreeze";
    rev = "python-seabreeze-v${version}";
    sha256 = "0bc2s9ic77gz9m40w89snixphxlzib60xa4f49n4zasjrddfz1l8";
  };

  outputs = [ "out" "udev" ];

  postInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    cp misc/10-oceanoptics.rules $udev/lib/udev/rules.d/10-oceanoptics.rules
  '';

  # underlying c libraries are tested and fail
  # (c libs are used with anaconda, which we don't care about as we use the alternative path, being that of pyusb).
  doCheck = false;

  propagatedBuildInputs = [ pyusb numpy ];

  setupPyBuildFlags = [ "--without-cseabreeze" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/ap--/python-seabreeze";
    description = "A python library to access Ocean Optics spectrometers";
    maintainers = [];
    license = licenses.mit;
  };
}
