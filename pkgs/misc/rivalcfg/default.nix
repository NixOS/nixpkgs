{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "rivalcfg";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "rivalcfg";
    rev = "v${version}";
    sha256 = "sha256-fCl+XY+R+QF7jWLkqii4v0sbXr7xoX3A3upm+XoBAms=";
  };

  propagatedBuildInputs = with python3Packages; [ hidapi setuptools ];

  checkInputs = [ python3Packages.pytest ];
  checkPhase = "pytest";

  # tests are broken
  doCheck = false;

  # this file has to be copied here instead of generated at build time because
  # rivalcfg --update-udev will fail if it detects a supported device but cannot
  # access it
  # it should probably be regenerated on version bumps
  postInstall = ''
    set -x
    mkdir -p $out/lib/udev/rules.d
    substitute ${./rival.rules} $out/lib/udev/rules.d/99-rivalcfg.rules --replace MODE=\"0666\" "MODE=\"0664\", GROUP=\"input\""
  '';

  meta = with lib; {
    description = "Utility program that allows you to configure SteelSeries Rival gaming mice";
    homepage = "https://github.com/flozz/rivalcfg";
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ ornxka ];
  };
}
