{ lib, fetchFromGitHub, php80 }:

php80.buildComposerProject (finalAttrs: {
  pname = "n98-magerun";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun";
    rev = finalAttrs.version;
    sha256 = "sha256-/RffdYgl2cs8mlq4vHtzUZ6j0viV8Ot/cB/cB1dstFM=";
  };

  vendorHash = "sha256-Kc+7bqUGR7sfiUQZCgg0G9Yny9TfRo9avdhp8Ck04Ko=";

  meta = with lib; {
    description = "The swiss army knife for Magento1/OpenMage developers";
    license = licenses.mit;
    homepage = "https://magerun.net/";
    changelog = "https://magerun.net/category/magerun/";
    maintainers = teams.php.members;
    platforms = lib.platforms.all;
  };
})
