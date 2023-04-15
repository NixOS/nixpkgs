{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "platformsh";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "platformsh";
    repo = "legacy-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YbzgPa0Y2PYTMZcWHdiejNHt+XgwJ6ZtahpV1RYs9OQ=";
  };

  vendorHash = "sha256-IcJyRLO1VJ+4oskv36E9ejtYD23aBeB9aRM30WcEIPU=";

  meta = {
    description = "The unified tool for managing your Platform.sh services from the command line.";
    homepage = "https://github.com/platformsh/platformsh-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shyim ];
    mainProgram = "platform";
  };
})
