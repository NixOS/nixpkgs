{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
}:

buildGoModule rec {
  pname = "vitess";
  version = "19.0.3";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Zy54nZCnwyZ1JNPvaKi0/bRt5g5ucPANwer/3pl4dGU=";
  };

  vendorHash = "sha256-QUzBxYEvxVzv4c8tKiFb+4NLy8RsXh0QTn9twfstMtw=";

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
