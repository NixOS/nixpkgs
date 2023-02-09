{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "8.7";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-A6EfP7l95eg9uL6NDqiPSzQ59JmTdE96UqunHETns9M=";
  };

  vendorHash = "sha256-LJ288Z8xz/Xoy5I2OAk9v5hxRUkQcRTmNaQ31kHE8gQ=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
