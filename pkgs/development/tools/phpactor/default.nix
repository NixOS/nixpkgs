{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpactor";
  version = "2023.04.10";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-nEerwOrXsghdLxG1iVK5pNgLkYFJWqmfL4HMRkjiYdI=";
  };

  vendorHash = "sha256-e7bZkcVKWkUet4wuyj0+VPCQlKvGRfdmmxK/SMEsf1M=";

  meta = with lib; {
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = licenses.mit;
    maintainers = with maintainers; [ ryantm ] ++ teams.php.members;
  };
})
