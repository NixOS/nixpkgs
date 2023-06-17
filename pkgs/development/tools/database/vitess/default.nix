{ lib, buildGoModule, fetchFromGitHub, sqlite }:

buildGoModule rec {
  pname = "vitess";
  version = "16.0.2";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8nFvNO+zb7Z0g2BMnlk+obDolCQrlfClOIg0mPW8gAU=";
  };

  vendorHash = "sha256-hC0skrEDXn6SXjH75ur77I0pHnGSURErAy97lmVvqro=";

  buildInputs = [ sqlite ];

  subPackages = [ "go/cmd/..." ];

  # integration tests require access to syslog and root
  doCheck = false;

  meta = with lib; {
    homepage = "https://vitess.io/";
    changelog = "https://github.com/vitessio/vitess/releases/tag/v${version}";
    description = "A database clustering system for horizontal scaling of MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
