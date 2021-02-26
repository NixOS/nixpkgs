{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-eRKUoRr0FPVNUZV5WenA7GlpYPAVRNKe0uRxOzFjhVE=";
  };

  vendorSha256 = "sha256-l6zHsis2fais5HQJQdfsSC0sPdcF4BeWoUznpl3Fh1g=";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
