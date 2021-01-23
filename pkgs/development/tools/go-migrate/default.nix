{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.14.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "1mgs3bngghmirmn0pw351m54darv8d5iymlxcjqw3vr0cyn5aqj0";
  };

  vendorSha256 = "071gfyx6iqla8ir7ianw1z62rdsds9shakzqs9wn34ll1kdbd4rv";

  subPackages = [ "cmd/migrate" ];

  meta = with lib; {
    homepage    = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license     = licenses.mit;
  };
}
