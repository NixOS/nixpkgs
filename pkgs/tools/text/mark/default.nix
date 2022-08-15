{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "8.3";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-HU7kPzcRhptMGuqsrHOTT3yZ9ALQGBK/cYZ8KbIO0RU=";
  };

  vendorSha256 = "sha256-Q628lMGV/Ys8BC5zMq3xXgmj74NYHQmP0IrMU5gyyMw=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
