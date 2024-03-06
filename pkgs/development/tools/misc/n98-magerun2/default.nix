{ lib
, fetchFromGitHub
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "n98-magerun2";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    rev = finalAttrs.version;
    hash = "sha256-a1T4SmeOEKRW/xS2VBPLZt6r9JdtaJn8YVvfRnzGdb4=";
  };

  vendorHash = "sha256-1j0/spum4C9j/HNVlHwUehAFYJOz7YvMVlC6dtbNYK0=";

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun2";
    maintainers = lib.teams.php.members;
  };
})
