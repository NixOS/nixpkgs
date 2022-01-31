{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "6.7";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-ZPKYZbWrR69V4SkXTiAK59Q2xpxkOC6KyAuspjzERwQ=";
  };

  vendorSha256 = "sha256-Yp47FBS8JN/idBfZG0z0f2A1bzob8KTPtZ7u0cNCrM8=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for syncing your markdown documentation with Atlassian Confluence pages";
    homepage = "https://github.com/kovetskiy/mark";
    license = licenses.asl20;
    maintainers = with maintainers; [ rguevara84 ];
  };
}
