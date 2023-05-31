{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpbench";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "phpbench";
    repo = "phpbench";
    rev = finalAttrs.version;
    sha256 = "sha256-gKrDRgwDLUj/aczAMWooZxstdRs1SnhEbhlH02/X1lM=";
  };

  # TODO: Open a PR against https://github.com/phpbench/phpbench
  # Missing `composer.lock` from the repository.
  composerLock = ./composer.lock;
  vendorHash = "sha256-a6MWmbT9X3EKhxrBIA8g3QUKwfk4O/PVRl8QGG4NSbo=";

  meta = with lib; {
    description = "Command-line shell and Unix scripting interface for Drupal";
    homepage = "https://github.com/drush-ops/drush";
    license = licenses.gpl2;
    maintainers = teams.php.members;
  };
})
