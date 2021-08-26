{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "6.2";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-Nk7DbZdz8BbsZO/Sx36ALNXRtSUju3X6S8M0yFs+Yz0=";
  };

  vendorSha256 = "sha256-y3Q8UebNbLy1jmxUC37mv+2l8dCU3b/Fk8XHn5u57p0=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
