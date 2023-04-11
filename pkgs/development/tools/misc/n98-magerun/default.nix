{ lib, fetchFromGitHub, php81 }:

php81.buildComposerProject (finalAttrs: {
  pname = "n98-magerun";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun";
    rev = finalAttrs.version;
    sha256 = "sha256-/RffdYgl2cs8mlq4vHtzUZ6j0viV8Ot/cB/cB1dstFM=";
  };

  vendorHash = "sha256-W5wzc94fGn5Q1jlLGOlTmGSFLSXRv+shdfSHtk9YIsg=";

  meta = {
    broken = true; # Not compatible with PHP 8.1, see https://github.com/netz98/n98-magerun/issues/1275
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento1/OpenMage developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
