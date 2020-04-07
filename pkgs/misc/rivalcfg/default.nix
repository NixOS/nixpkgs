{ lib, fetchFromGitHub, python3Packages }:

with python3Packages; buildPythonPackage rec {
  pname = "rivalcfg";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "flozz";
    repo = "rivalcfg";
    rev = "v${version}";
    sha256 = "1xfaxc2qhbgi46m8ihhcgk9xfgkrvaqk0fhfav13378cihhdwwpn";
  };

  propagatedBuildInputs = [ hidapi ];

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    substitute $src/rivalcfg/data/99-steelseries-rival.rules $out/etc/udev/rules.d/99-steelseries-rival.rules --replace MODE=\"0666\" "MODE=\"0664\", GROUP=\"users\""
  '';

  meta = with lib; {
    description = "Small CLI utility program that allows you to configure SteelSeries Rival gaming mice";
    homepage = "https://github.com/flozz/rivalcfg";
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ ornxka ];
  };
}