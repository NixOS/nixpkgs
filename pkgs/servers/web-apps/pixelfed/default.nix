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
  version = "0.11.13";

  src = fetchFromGitHub {
    owner = "pixelfed";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-bEwKaC9fSOGLQbjsuPuIdMMbO3kzvzQxWQR8C2A4mQc=";
  };

  vendorHash = "sha256-ahQsOq3qOMGt3b0Ebac4xex+MP9knTmjyCy0PSNE4W8=";

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
