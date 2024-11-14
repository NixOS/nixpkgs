{
  php,
  fetchFromGitHub,
  lib,
}:

php.buildComposerProject (finalAttrs: {
  pname = "hmr_enabler";
  # composer doesn't support our unstable version format
  # version = "0-unstable-2024-08-24";
  version = "0";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "hmr_enabler";
    rev = "d5d9d330d405ac4aa0de1a87d1133784560462ed";
    hash = "sha256-uLCpwvMVQ20z9vlO5q/GVPnaaQZ7ZjE8+V/zuqaB9Yo=";
  };

  composerNoDev = false;

  vendorHash = "sha256-ZuEEcFT+q49CCooEwdiu2Co345s0ZCC7jeEksi6A99A=";

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/hmr_enabler/* $out/
    rm -r $out/share $out/composer.* $out/Makefile $out/psalm.xml $out/tests
  '';

  meta = {
    description = " Development Nextcloud app to enable apps to use hot module reloading";
    homepage = "https://github.com/nextcloud/hmr_enabler";
    changelog = "https://github.com/nextcloud/hmr_enabler/blob/master/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ onny ];
  };

})
