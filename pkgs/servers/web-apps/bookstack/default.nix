{
  pkgs,
  stdenv,
  lib,
  fetchFromGitHub,
  dataDir ? "/var/lib/bookstack",
}:

let
  package =
    (import ./composition.nix {
      inherit pkgs;
      inherit (stdenv.hostPlatform) system;
      noDev = true; # Disable development dependencies
    }).overrideAttrs
      (attrs: {
        installPhase =
          attrs.installPhase
          + ''
            rm -R $out/storage $out/public/uploads
            ln -s ${dataDir}/.env $out/.env
            ln -s ${dataDir}/storage $out/storage
            ln -s ${dataDir}/public/uploads $out/public/uploads
          '';
      });

in
package.override rec {
  pname = "bookstack";
  version = "24.05.4";

  src = fetchFromGitHub {
    owner = "bookstackapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1aa4im2khxycv5i2ff23ss91p4kr7d2a4yhjm0k0n6av64zhz2x3";
  };

  meta = with lib; {
    description = "Platform to create documentation/wiki content built with PHP & Laravel";
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
