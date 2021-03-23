{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "5.4";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-IDW8dd2Bgr936hUKkfkoQ/kBnN+0uacJ1uX4Xhd27Vc=";
  };

  vendorSha256 = "sha256-nneQ0B7PyHAqiOzrmWqSssZM8B3np4VFUJLBqUvkjZE=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
