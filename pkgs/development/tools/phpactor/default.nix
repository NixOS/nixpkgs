{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpactor";
  version = "2023.12.03.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-zLSGzaUzroWkvFNCj3uA9KdZ3K/EIQOZ7HzV6Ms5/BE=";
  };

  vendorHash = "sha256-0jvWbQubPXDhsXqEp8q5R0Y7rQX3UiccGDF3HDBeh7o=";

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = [ lib.maintainers.ryantm ] ++ lib.teams.php.members;
  };
})
