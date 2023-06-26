{ lib
, pkgs
, stdenv
, fetchFromGitHub
, dataDir ? "/var/lib/snipe-it"
, mariadb
, nixosTests
}:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  }).overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      # Before symlinking the following directories, copy the invalid_barcode.gif
      # to a different location. The `snipe-it-setup` oneshot service will then
      # copy the file back during bootstrap.
      mkdir -p $out/share/snipe-it
      cp $out/public/uploads/barcodes/invalid_barcode.gif $out/share/snipe-it/

      rm -R $out/storage $out/public/uploads $out/bootstrap/cache
      ln -s ${dataDir}/.env $out/.env
      ln -s ${dataDir}/storage $out/
      ln -s ${dataDir}/public/uploads $out/public/uploads
      ln -s ${dataDir}/bootstrap/cache $out/bootstrap/cache

      chmod +x $out/artisan

      substituteInPlace config/database.php --replace "env('DB_DUMP_PATH', '/usr/local/bin')" "env('DB_DUMP_PATH', '${mariadb}/bin')"
    '';
  });

in package.override rec {
  pname = "snipe-it";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "snipe";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kqrq0blamqbfh8dxfyvn2m4q7yphamh4yvpfs7iyb3lb7z7a75i";
  };

  passthru.tests = nixosTests.snipe-it;

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
}
