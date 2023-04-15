{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "platformsh";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "platformsh";
    repo = "legacy-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1DCv4M7nCDrBeMoULO8kWQkMgEYGZmBaBfbsVpMCOVA=";
  };

  vendorHash = "sha256-VjM3Q1iBIojsLSDmUPY+iN2N4UnaZwJNataH3x4YHr4=";

  meta = with lib; {
    description = "The unified tool for managing your Platform.sh services from the command line.";
    homepage = "https://github.com/platformsh/platformsh-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
    mainProgram = "platform";
  };
})
