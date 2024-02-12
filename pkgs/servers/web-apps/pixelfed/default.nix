{ lib
, stdenv
, fetchFromGitHub
, php
, nixosTests
, nix-update-script
, dataDir ? "/var/lib/pixelfed"
, runtimeDir ? "/run/pixelfed"
}:

php.buildComposerProject (finalAttrs: {
  pname = "pixelfed";
  version = "0.11.11";

  src = fetchFromGitHub {
    owner = "pixelfed";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-ytE1ZCKQvoigC8jKPfQ/17jYA0XYOzospq7wY18o2Nk=";
  };

  vendorHash = "sha256-nRCrmF1p+fZI+iyrM5I3bVCSwjQdn8BSW8Jj62lpn8E=";
  # Needed because buzz/laravel-h-captcha is pinned to 1.0.4 in composer.json
  composerStrictValidation = false;

  postInstall = ''
    mv "$out/share/php/${finalAttrs.pname}"/* $out
    rm -R $out/bootstrap/cache
    # Move static contents for the NixOS module to pick it up, if needed.
    mv $out/bootstrap $out/bootstrap-static
    mv $out/storage $out/storage-static
    ln -s ${dataDir}/.env $out/.env
    ln -s ${dataDir}/storage $out/
    ln -s ${dataDir}/storage/app/public $out/public/storage
    ln -s ${runtimeDir} $out/bootstrap
    chmod +x $out/artisan
  '';

  passthru = {
    tests = { inherit (nixosTests) pixelfed; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A federated image sharing platform";
    license = licenses.agpl3Only;
    homepage = "https://pixelfed.org/";
    maintainers = with maintainers; [ raitobezarius ];
    platforms = php.meta.platforms;
  };
})
