{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "github-copilot-cli.fish";
  version = "0.1.33";

  src = fetchFromGitHub {
    owner = "z11i";
    repo = pname;
    rev = version;
    hash = "sha256-dhACPlFrw1Z0dW0eA0IMnOelYJc7Fyz2D9u+rL1pyiM=";
  };

  meta = with lib; {
    description = "GitHub Copilot CLI aliases for Fish Shell";
    homepage = "https://github.com/z11i/github-copilot-cli.fish";
    license = licenses.asl20;
    maintainers = [ maintainers.malo ];
  };
}
