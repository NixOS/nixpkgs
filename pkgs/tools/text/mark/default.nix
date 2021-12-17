{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mark";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner  = "kovetskiy";
    repo   = "mark";
    rev    = version;
    sha256 = "sha256-NTe7J08Lu4uVI/mLj4m87n1BZXiUPDvi5OtjJfddJw8=";
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
