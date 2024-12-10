{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gcov2lcov";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "jandelgado";
    repo = "gcov2lcov";
    rev = "v${version}";
    hash = "sha256-S5fAhd0bh1XEeQwaya8LvnKQ/iz4PjAbpjK4uFI6H1g=";
  };

  vendorHash = "sha256-r95PFkTywGiDIEnDfLpzt97SkuDeXo4xg2N7ikG0hs0=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Some checks depend on looking up vcs root
  checkPhase = false;

  meta = with lib; {
    description = "Convert go coverage files to lcov format";
    mainProgram = "gcov2lcov";
    homepage = "https://github.com/jandelgado/gcov2lcov";
    changelog = "https://github.com/jandelgado/gcov2lcov/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
