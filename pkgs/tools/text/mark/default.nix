{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "8.9";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-mtATdRUNTBXy/r7VoxHi1SNTv8fGz7svil6dOkqq5Bk=";
  };

  vendorHash = "sha256-V14i+8h0HxxHVDNfgaHUxdzEnB+mKL5iGjBwMjPDZ9s=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
