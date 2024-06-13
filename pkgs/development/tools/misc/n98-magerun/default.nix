{ lib
, fetchFromGitHub
, php81
}:

php81.buildComposerProject (finalAttrs: {
  pname = "n98-magerun";
  version = "1.97.14";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun";
    rev = finalAttrs.version;
    hash = "sha256-Rs+TPHGaD8QAES1vOsQNlvflT8ng5lagQ+KmubtOgvA=";
  };

  vendorHash = "sha256-lTpHWaox/5XIeWkNrYwG+V+KRPeEkQVbl+TLoi2ECNI=";

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento1/OpenMage developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun";
    maintainers = lib.teams.php.members;
  };
})
