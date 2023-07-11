{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ots";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "sniptt-official";
    repo = pname;
    rev = "v${version}";
    sha256 = "Oxs2ytf0rY9QYzVaLUkqyX15oWjas3ukSkq9D1TYbDE=";
  };

  vendorSha256 = "qYk8T0sYIO0wJ0R0j+0VetCy11w8usIRRdBm/Z6grJE=";

  ldflags = [ "-X main.version=${version}" "-X main.buildSource=nix" ];

  meta = with lib; {
    description = "Share end-to-end encrypted secrets with others via a one-time URL";
    homepage = "https://ots.sniptt.com";
    changelog = "https://github.com/sniptt-official/ots/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ elliot ];
  };
}
