{ lib, buildGoModule, fetchFromGitHub, sqlite }:

buildGoModule rec {
  pname = "vitess";
  version = "19.0.4";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rP2a/t+5FhGIj9T6CQodMp9YXYf3fL5oBdFpAn7e7hw=";
  };

  vendorHash = "sha256-BlHd5GQJwdntmvVti+Jvfw65LrYM+hjwdvQ0duKk5d8=";

  buildInputs = [ sqlite ];

  subPackages = [ "go/cmd/..." ];

  # integration tests require access to syslog and root
  doCheck = false;

  meta = with lib; {
    homepage = "https://vitess.io/";
    changelog = "https://github.com/vitessio/vitess/releases/tag/v${version}";
    description = "Database clustering system for horizontal scaling of MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
