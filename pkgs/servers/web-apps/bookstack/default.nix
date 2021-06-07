{ pkgs, system, lib, fetchFromGitHub, dataDir ? "/var/lib/bookstack" }:

let
  package = (import ./composition.nix {
    inherit pkgs system;
    noDev = true; # Disable development dependencies
  }).overrideAttrs (attrs : {
    installPhase = attrs.installPhase + ''
      rm -R $out/storage $out/public/uploads
      ln -s ${dataDir}/.env $out/.env
      ln -s ${dataDir}/storage $out/storage
      ln -s ${dataDir}/public/uploads $out/public/uploads
    '';
  });

in package.override rec {
  name = "bookstack";
  version = "21.05";

  src = fetchFromGitHub {
    owner = "bookstackapp";
    repo = name;
    rev = "v${version}";
    sha256 = "0vn1n2l66xsv2qjhh53dm28vwm7d9ba62syx2gviznva1lsyn78z";
  };

  meta = with lib; {
    description = "A platform to create documentation/wiki content built with PHP & Laravel";
    longDescription = ''
      A platform for storing and organising information and documentation.
      Details for BookStack can be found on the official website at https://www.bookstackapp.com/.
    '';
    homepage = "https://www.bookstackapp.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ ymarkus ];
    platforms = platforms.linux;
  };
}
