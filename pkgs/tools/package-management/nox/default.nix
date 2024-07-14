{ lib, python3Packages, fetchurl, git }:

python3Packages.buildPythonApplication rec {
  pname = "nox";
  version = "0.0.6";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/n/nix-nox/nix-nox-${version}.tar.gz";
    hash = "sha256-P11HgQ45dRGWF/YbUVCYDrFYCgb7NcwMPhvCBm2Di+E=";
  };

  patches = [ ./nox-review-wip.patch ];

  buildInputs = [ python3Packages.pbr git ];

  propagatedBuildInputs = with python3Packages; [
      dogpile-cache
      click
      requests
      characteristic
      setuptools
    ];

  meta = {
    homepage = "https://github.com/madjar/nox";
    description = "Tools to make nix nicer to use";
    maintainers = [ lib.maintainers.madjar ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
