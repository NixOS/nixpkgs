{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buildkite-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-AIa+hEYtPJ4CFvAFSpNJFxY+B3+DJH1Q0hL/3BD/yN0=";
  };

  vendorSha256 = "sha256-4AH9PZWSrBXi9w4Mr7dpXqDkQZGzuELG876YCaFTj2Q=";

  doCheck = false;

  subPackages = [ "cmd/bk" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A command line interface for Buildkite";
    homepage = "https://github.com/buildkite/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ groodt ];
    mainProgram = "bk";
  };
}
