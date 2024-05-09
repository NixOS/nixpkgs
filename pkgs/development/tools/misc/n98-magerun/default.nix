{ lib
, fetchFromGitHub
, php81
}:

php81.buildComposerProject (finalAttrs: {
  pname = "n98-magerun";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun";
    rev = finalAttrs.version;
    hash = "sha256-/RffdYgl2cs8mlq4vHtzUZ6j0viV8Ot/cB/cB1dstFM=";
  };

  vendorHash = "sha256-n608AY6AQdVuN3hfVQk02vJQ6hl/0+4LVBOsBL5o3+8=";

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento1/OpenMage developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun";
    maintainers = lib.teams.php.members;
  };
})
