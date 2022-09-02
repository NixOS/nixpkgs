{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.84.0";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-14S0Y1ax0bg7nD4iCEujwLIZSjpWYaLWidpYVwQB0dw=";
  };

  vendorSha256 = "sha256-XVGFJv9TYjuwVubTcFVI2b+M2ZDE1Jv4u/dxowcLL2s=";

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
