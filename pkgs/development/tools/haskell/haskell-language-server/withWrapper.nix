{ lib, supportedGhcVersions ? [ "865" "884" "8102" ], stdenv, haskellPackages
, haskell }:
#
# The recommended way to override this package is
#
# pkgs.haskell-language-server.override { supportedGhcVersions = [ "901" ]; }
#
# for example. Read more about this in the haskell-language-server section of the nixpkgs manual.
#
let
  inherit (lib) concatStringsSep concatMapStringsSep take splitString;
  getPackages = version: haskell.packages."ghc${version}";
  getMajorVersion = packages:
    concatStringsSep "." (take 2 (splitString "." packages.ghc.version));
  tunedHls = hsPkgs:
    haskell.lib.justStaticExecutables
    (haskell.lib.overrideCabal hsPkgs.haskell-language-server (old: {
      postInstall = ''
        remove-references-to -t ${hsPkgs.ghc} $out/bin/haskell-language-server
        remove-references-to -t ${hsPkgs.shake.data} $out/bin/haskell-language-server
        remove-references-to -t ${hsPkgs.js-jquery.data} $out/bin/haskell-language-server
        remove-references-to -t ${hsPkgs.js-dgtable.data} $out/bin/haskell-language-server
        remove-references-to -t ${hsPkgs.js-flot.data} $out/bin/haskell-language-server
      '';
    }));
  targets = version:
    let packages = getPackages version;
    in [
      "haskell-language-server-${packages.ghc.version}"
      "haskell-language-server-${getMajorVersion packages}"
    ];
  makeSymlinks = version:
    concatMapStringsSep "\n" (x:
      "ln -s ${
        tunedHls (getPackages version)
      }/bin/haskell-language-server $out/bin/${x}") (targets version);
  pkg = tunedHls haskellPackages;
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
