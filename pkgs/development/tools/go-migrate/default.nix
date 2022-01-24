{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.15.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-t4F4jvXexxCqKINaaczeG/B2vLSG87/qZ+VQitfAF4Y=";
  };

  vendorSha256 = "sha256-qgjU8mUdk8S0VHmWiTK/5euwhRQ4y3o4oRxG2EHF+7E=";

  subPackages = [ "cmd/migrate" ];

  meta = with lib; {
    homepage    = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license     = licenses.mit;
    mainProgram = "migrate";
  };
}
