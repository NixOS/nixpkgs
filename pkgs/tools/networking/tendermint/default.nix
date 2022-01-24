{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fSDmwZNKAHXcMtNZlqJmUFkuFdZLkDbnn+ZrNtnszgU=";
  };

  vendorSha256 = "sha256-DktuZ0NUyg8LbYklxde2ZZJ8/WOyBq50E9yEHtS+Hqw=";

  subPackages = [ "cmd/tendermint" ];

  preBuild = ''
    makeFlagsArray+=(
      "-ldflags=-s -w -X github.com/tendermint/tendermint/version.GitCommit=${src.rev}"
    )
  '';

  meta = with lib; {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short";
    homepage = "https://tendermint.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
