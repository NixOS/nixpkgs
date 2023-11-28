{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phpunit";
  version = "10.4.2";

  src = fetchFromGitHub {
    owner = "sebastianbergmann";
    repo = "phpunit";
    rev = finalAttrs.version;
    hash = "sha256-7hgDeg8K+Iuo8Lb8mV5ACQV3BDBotKIZ0/IdlLCXuIc=";
  };

  # Add missing composer.lock
  # https://github.com/sebastianbergmann/phpunit/pull/5576
  composerLock = ./composer.lock;
  vendorHash = "sha256-PYcXB8MEhZabAreR2GluyrEkgnTvUEgEkfFnUT5Fqps=";

  meta = {
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${finalAttrs.version}/ChangeLog-${lib.versions.majorMinor finalAttrs.version}.md";
    description = "PHP Unit Testing framework";
    homepage = "https://phpunit.de";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ] ++ lib.teams.php.members;
  };
})
