{ lib
, stdenv
, fetchFromGitHub
, phpPackages
, pkgs
, dataDir ? "/var/lib/pixelfed"
}:

let
  package = (import ./composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  }).overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      rm -R $out/bootstrap/cache $out/storage
      ln -s ${dataDir}/.env $out/.env
      ln -s ${dataDir}/storage $out/
      ln -s ${dataDir}/storage/app/public $out/public/storage
      ln -s ${dataDir}/bootstrap/cache $out/bootstrap/cache
      chmod +x $out/artisan
    '';
  });

in package.override rec {
  pname = "pixelfed";
  version = "UNSTABLE-01-09-2022";

  # GitHub distribution does not include vendored files
  src = fetchFromGitHub {
    owner = "pixelfed";
    repo = pname;
    # use an unstable version until a release contains composer.lock
    rev = "ee0cb393c642aa3781a7ed2eec43b3113843b566";
    hash = "sha256-cw/9oXz15tigMlOV8QW6/DIrRlXgQhpdSIexZUlxNOA=";
  };

  meta = with lib; {
    description = "A federated image sharing platform";
    license = licenses.agpl3Only;
    homepage = "https://pixelfed.org/";
    maintainers = with maintainers; [ bezmuth ];
    platforms = platforms.all;
  };
}
