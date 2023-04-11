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
  vendorHash = "sha256-AWCDfZk+BB5/0Gzs73Lcl/FztiKLbZFdRhU9aRZ1bPg=";

  meta = with lib; {
    description = "PHP Unit Testing framework";
    license = licenses.bsd3;
    homepage = "https://phpunit.de";
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    maintainers = with maintainers; [ onny ] ++ teams.php.members;
    platforms = platforms.all;
  };
})
