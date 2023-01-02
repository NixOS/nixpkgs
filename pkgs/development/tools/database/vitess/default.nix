{ lib, buildGoModule, fetchFromGitHub, sqlite }:

buildGoModule rec {
  pname = "vitess";
  version = "15.0.2";

  src = fetchFromGitHub {
    owner = "vitessio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NkJqJYmUf92QiPazxRWNsxZh0Pvc73l35hP1gmk4Fv0=";
  };

  vendorHash = "sha256-+yCznSxv0EWoKiQIgFEQ/iUxrlQ5A1HYNkoMiRDG3ik=";

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
