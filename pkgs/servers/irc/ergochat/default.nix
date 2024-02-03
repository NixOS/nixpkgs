{ buildGoModule, fetchFromGitHub, lib, nixosTests }:

buildGoModule rec {
  pname = "ergo";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "ergochat";
    repo = "ergo";
    rev = "v${version}";
    sha256 = "sha256-LBKGwtprhtDHaghnU6YPQ4Pf2fqD8VN7OV9gzvFgLPY=";
  };

  vendorHash = null;

  passthru.tests.ergochat = nixosTests.ergochat;

  meta = {
    changelog = "https://github.com/ergochat/ergo/blob/v${version}/CHANGELOG.md";
    description = "A modern IRC server (daemon/ircd) written in Go";
    homepage = "https://github.com/ergochat/ergo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lassulus tv ];
    platforms = lib.platforms.linux;
  };
}
