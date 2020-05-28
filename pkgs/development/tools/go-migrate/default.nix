{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "Dw+TiuksgOfFBCzNc9rsxyQCoXES+fpr4wTrZfqohGM=";
  };

  vendorSha256 = "CezVFRZ/cknvK4t/MjyP46zJACGkzj4CZ5JVQ502Ihw=";

  subPackages = [ "cmd/migrate" ];

  meta = with stdenv.lib; {
    homepage    = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library.";
    maintainers = with maintainers; [ offline ];
    license     = licenses.mit;
  };
}
