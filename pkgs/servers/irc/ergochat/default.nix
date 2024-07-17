{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "ergo";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "ergochat";
    repo = "ergo";
    rev = "v${version}";
    sha256 = "sha256-WQvXrG82hcPd4viA1cyIsTd5HbR0KD1b5r2me8MKoR8=";
  };

  vendorHash = null;

  passthru.tests.ergochat = nixosTests.ergochat;

  meta = {
    changelog = "https://github.com/ergochat/ergo/blob/v${version}/CHANGELOG.md";
    description = "A modern IRC server (daemon/ircd) written in Go";
    mainProgram = "ergo";
    homepage = "https://github.com/ergochat/ergo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lassulus
      tv
    ];
    platforms = lib.platforms.linux;
  };
}
