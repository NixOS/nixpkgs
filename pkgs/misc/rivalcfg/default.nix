{ lib, fetchFromGitHub, python3Packages }:

with python3Packages; buildPythonPackage rec {
  pname = "rivalcfg";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "rivalcfg";
    rev = "v${version}";
    sha256 = "sha256:1jms1dc342cxhagbrnjq130zkw0gjqggx33iy44d4pnxrz873wgz";
  };

  propagatedBuildInputs = [ hidapi setuptools ];

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  # tests are broken
  doCheck = false;

  # this file has to be copied here instead of generated at build time because
  # rivalcfg --update-udev will fail if it detects a supported device but cannot
  # access it
  # it should probably be regenerated on version bumps
  postInstall = ''
    set -x
    mkdir -p $out/etc/udev/rules.d
    substitute ${./rival.rules} $out/etc/udev/rules.d/99-rivalcfg.rules --replace MODE=\"0666\" "MODE=\"0664\", GROUP=\"input\""
  '';

  meta = with lib; {
    description = "Utility program that allows you to configure SteelSeries Rival gaming mice";
    homepage = "https://github.com/flozz/rivalcfg";
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ ornxka ];
  };
}
