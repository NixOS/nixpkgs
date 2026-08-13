{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "github-copilot-cli.fish";
  version = "0.1.33.1";

  src = fetchFromGitHub {
    owner = "z11i";
    repo = "github-copilot-cli.fish";
    tag = version;
    hash = "sha256-CFXbeO0euC/UtvQV0KCz4WQfdJgsuXKPM6M9oaw7hvg=";
  };

  meta = {
    description = "GitHub Copilot CLI aliases for Fish Shell";
    homepage = "https://github.com/z11i/github-copilot-cli.fish";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malo ];
  };
}
