{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "n98-magerun2";
  version = "7.0.3";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    rev = finalAttrs.version;
    sha256 = "sha256-nONON259eYPtuJLaBOdMfZ62NVc1e8BYHKhpsqxoLJ8=";
  };

  vendorHash = "sha256-9xO5Nl8V7JexP9wLzn4NYj2eDf3gALjtYozF1EXOYlQ=";

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
