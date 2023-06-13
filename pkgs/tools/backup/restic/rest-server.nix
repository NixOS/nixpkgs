{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "restic-rest-server";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${version}";
    hash = "sha256-FnT7AG9na/KdWimUqhcF1QndGdT+Nc8ao5zlSeN/fJ0=";
  };

  vendorHash = "sha256-Q0XazJmfmAwR2wXD/RXO6nPiNyWFubBYL3kNFKBRMzc=";

  meta = with lib; {
    changelog = "https://github.com/restic/rest-server/blob/${src.rev}/CHANGELOG.md";
    description = "A high performance HTTP server that implements restic's REST backend API";
    homepage = "https://github.com/restic/rest-server";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
