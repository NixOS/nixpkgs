{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "8.4";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-b9oWuIdCVsbPJYaSDsvKI1rOvcH97aoeN748B89XxBQ=";
  };

  vendorSha256 = "sha256-t2xiw1Z0BIT7pO4Z16XmsJE72RgL9Hobfy7LakpEYh4=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
