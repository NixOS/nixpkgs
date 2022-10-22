{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.88.0";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FlkDequdr8dOgbk4fFlLnBSPWvOWz0tTmPJTlXxV6fg=";
  };

  vendorSha256 = "sha256-HX4seTtO5DWeR1PqXnYKIKq1/wP6/ppTclDpkQSzgbM=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  # tests fail on read-only filesystem
  doCheck = false;

  meta = with lib; {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
}
