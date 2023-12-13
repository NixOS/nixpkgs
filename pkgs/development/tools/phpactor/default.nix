{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpactor";
  version = "2023.08.06-1";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-NI+CLXlflQ8zQ+0AbjhJFdV6Y2+JGy7XDj0RBJ4YRRg=";
  };

  vendorHash = "sha256-XGVZw6t8CHcv39YHkn/mW6fdl65kFakADLOEWbXfh/g=";

  meta = {
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = [ lib.maintainers.ryantm ] ++ lib.teams.php.members;
  };
})
