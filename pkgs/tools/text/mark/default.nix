{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "3.5";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "0za4n2caqr3gflfxr1hdd328g7r52h7x0ws7r9mjvdnmwjgc0b2b";
  };

  vendorSha256 = "1hvizcg5b3y2qgjiw77rb795xz9w1dzr3b8q2ji48ihll27g9f0m";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
