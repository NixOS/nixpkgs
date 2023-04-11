{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpactor";
  version = "2023.06.17";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-NI+CLXlflQ8zQ+0AbjhJFdV6Y2+JGy7XDj0RBJ4YRRg=";
  };

  vendorHash = "sha256-2la0VG2EDZkNujFAEvbelN4OLx/KS8UJfojcknHiwAk=";

  meta = {
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryantm ] ++ lib.teams.php.members;
  };
})
