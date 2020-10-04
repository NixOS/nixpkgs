{ lib, supportedGhcVersions ? [ "865" "884" "8102" ], stdenv, haskellPackages
, haskell }:
let
  inherit (lib) concatStringsSep concatMapStringsSep take splitString;
  getPackages = version: haskell.packages."ghc${version}";
  getMajorVersion = packages:
    concatStringsSep "." (take 2 (splitString "." packages.ghc.version));
  targets = version:
    let packages = getPackages version;
    in [
      "haskell-language-server-${packages.ghc.version}"
      "haskell-language-server-${getMajorVersion packages}"
    ];
  makeSymlinks = version:
    concatMapStringsSep "\n" (x:
      "ln -s ${
        haskell.lib.justStaticExecutables
        (getPackages version).haskell-language-server
      }/bin/haskell-language-server $out/bin/${x}") (targets version);
  pkg =
    haskell.lib.justStaticExecutables haskellPackages.haskell-language-server;
in stdenv.mkDerivation {
  pname = "haskell-language-server";
  version = haskellPackages.haskell-language-server.version;
  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${pkg}/bin/haskell-language-server $out/bin/haskell-language-server
    ln -s ${pkg}/bin/haskell-language-server-wrapper $out/bin/haskell-language-server-wrapper
    ${concatMapStringsSep "\n" makeSymlinks supportedGhcVersions}
  '';
  meta = haskellPackages.haskell-language-server.meta // {
    maintainers = [ lib.maintainers.maralorn ];
    longDescription = ''
      This package provides haskell-language-server, haskell-language-server-wrapper, ${
        concatMapStringsSep ", " (x: concatStringsSep ", " (targets x))
        supportedGhcVersions
      }.

      You can override the list supportedGhcVersions.
    '';
  };
}
