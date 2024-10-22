{ lib
, fetchFromGitHub
, php
, nixosTests
, nix-update-script
, dataDir ? "/var/lib/pixelfed"
, runtimeDir ? "/run/pixelfed"
}:

php.buildComposerProject (finalAttrs: {
  pname = "pixelfed";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "pixelfed";
    repo = "pixelfed";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CKjqnxp7p2z/13zfp4HQ1OAmaoUtqBKS6HFm6TV8Jwg=";
  };

  vendorHash = "sha256-zjIjGkR9MCnjRho/ViqZ5EbS9MJ7OQ1kkg93jBssuZU=";

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
    description = "Federated image sharing platform";
    license = licenses.agpl3Only;
    homepage = "https://pixelfed.org/";
    maintainers = [ ];
    platforms = php.meta.platforms;
  };
})
