{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "shadowfox";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "SrKomodo";
    repo = "shadowfox-updater";
    rev = "v${version}";
    sha256 = "125mw70jidbp436arhv77201jdp6mpgqa2dzmrpmk55f9bf29sg6";
  };

  vendorSha256 = "17m0ssfw9n3g2lkv63qajz3adrk5yp0c9hx66x7dl79snwqd49yg";

  doCheck = false;

  ldflags = [
    "-X main.tag=v${version}"
  ];

  meta = with lib; {
    description = ''
      This project aims at creating a universal dark theme for Firefox while
      adhering to the modern design principles set by Mozilla.
    '';
    homepage = "https://overdodactyl.github.io/ShadowFox/";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
  };
}
