{ lib
, dataDir ? "/var/lib/snipe-it"
, fetchFromGitHub
, mariadb
, nixosTests
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "snipe-it";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "snipe";
    repo = "snipe-it";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EU+teGxo7YZkD7kNXk9jRyARpzWz5OMRmaWqQ6eMKYY=";
  };

  vendorHash = "sha256-JcBcrETbjGJFlG1dH/XXqmb9MlKr0ICdnEx7/61Z5io=";

  postInstall = ''
    snipe_it_out="$out/share/php/snipe-it"

    # Before symlinking the following directories, copy the invalid_barcode.gif
    # to a different location. The `snipe-it-setup` oneshot service will then
    # copy the file back during bootstrap.
    mkdir -p $out/share/snipe-it
    cp $snipe_it_out/public/uploads/barcodes/invalid_barcode.gif $out/share/snipe-it/

    rm -R $snipe_it_out/storage $snipe_it_out/public/uploads $snipe_it_out/bootstrap/cache
    ln -s ${dataDir}/.env $snipe_it_out/.env
    ln -s ${dataDir}/storage $snipe_it_out/
    ln -s ${dataDir}/public/uploads $snipe_it_out/public/uploads
    ln -s ${dataDir}/bootstrap/cache $snipe_it_out/bootstrap/cache

    chmod +x $snipe_it_out/artisan

    substituteInPlace $snipe_it_out/config/database.php --replace "env('DB_DUMP_PATH', '/usr/local/bin')" "env('DB_DUMP_PATH', '${mariadb}/bin')"
  '';

  passthru = {
    tests = nixosTests.snipe-it;
    phpPackage = php;
  };

  meta = with lib; {
    description = "A free open source IT asset/license management system";
    longDescription = ''
      Snipe-IT was made for IT asset management, to enable IT departments to track
      who has which laptop, when it was purchased, which software licenses and accessories
      are available, and so on.
      Details for snipe-it can be found on the official website at https://snipeitapp.com/.
    '';
    homepage = "https://snipeitapp.com/";
    changelog = "https://github.com/snipe/snipe-it/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ yayayayaka ];
    platforms = platforms.linux;
  };
})
