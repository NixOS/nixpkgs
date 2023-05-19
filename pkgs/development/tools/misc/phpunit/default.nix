{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "10.1.3";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-AJuKGxVF/7bwrQd3z/rotAhMflEsAGCKB7u8i8zZl+0=";
  };

  # TODO: Open a PR against https://github.com/sebastianbergmann/phpunit
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-O5ZstTitA/4KNwuAeJg2tS+ua9qsflzaRVf3k1NerBE=";

  meta = {
    description = "PHP Unit Testing framework";
    license = lib.licenses.bsd3;
    homepage = "https://phpunit.de";
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
    platforms = lib.platforms.all;
  };
})
