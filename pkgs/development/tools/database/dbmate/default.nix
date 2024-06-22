{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-r0C03K/jyL8P0iysa6R1AaHVpB6Bw/FUwBIz7V/rGak=";
  };

  vendorHash = "sha256-8NVkpJEAp3UsM2BnZVcavK+89MELo0T96tTcY0pke6Q=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
