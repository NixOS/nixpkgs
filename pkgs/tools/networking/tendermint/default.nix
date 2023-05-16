{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "tendermint";
  version = "0.35.9";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3tggW+M3vZChDT1g77W5M3hchEN6pTSVvkrZda6ZTCY=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-/enY0qERFzAIJNcuw1djRGoAcmtz7R5Ikvlts0f7rLc=";
=======
  vendorSha256 = "sha256-/enY0qERFzAIJNcuw1djRGoAcmtz7R5Ikvlts0f7rLc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
