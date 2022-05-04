{ buildGoModule, fetchFromGitHub, lib, nixosTests }:

buildGoModule rec {
  pname = "ergo";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "ergochat";
    repo = "ergo";
    rev = "v${version}";
    sha256 = "sha256-RxsmkTfHymferS/FRW0sLnstKfvGXkW6cEb/JbeS4lc=";
  };

  vendorSha256 = null;

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
