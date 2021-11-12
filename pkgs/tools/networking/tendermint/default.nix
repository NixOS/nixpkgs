{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.34.14";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/FYkwHamJTty/h80KaNAmyNg0wCqiOAA3o2whouAOZc=";
  };

  vendorSha256 = "sha256-9wjiL8/fhWLuGglFkS8OH026zwbrmuadB3goBqFqnvc=";

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
