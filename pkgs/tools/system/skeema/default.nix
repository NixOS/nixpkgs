{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skeema";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "skeema";
    repo = "skeema";
    rev = "v${version}";
    sha256 = "sha256-hO8F3J8obi99dCT6L9OcbyVhch3z6JLeJHIvrNJemAE=";
  };

  vendorSha256 = null;

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  checkFlags = [ "-short" ];

  meta = with lib; {
    description = "Declarative pure-SQL schema management for MySQL and MariaDB";
    homepage = "https://skeema.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
