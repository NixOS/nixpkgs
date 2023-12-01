{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "10.5.0";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-CpgYMUJE7c2eRBYkK/vMRdGgzY7Y7K/wMmyUH+Bssjs=";
  };

  vendorHash = "sha256-uUdgz3ZZ+3nU07pUC1sdkNgU1b1beo3sS/yySUzdZwU=";

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
  };
})
