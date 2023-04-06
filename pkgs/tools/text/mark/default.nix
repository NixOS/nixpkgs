{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "9.0.3";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-9YEiTHxXcUMlIDIATzpZZMtOfuv69fFYDUQcjtL51l0=";
  };

  vendorHash = "sha256-YLAx1Khfifo9H4u7Cu7wNLhDO/6QXKYiKm1Ea1oh9uU=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
