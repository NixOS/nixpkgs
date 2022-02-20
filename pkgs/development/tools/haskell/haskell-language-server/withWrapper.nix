{ lib
, stdenv
, supportedGhcVersions ? [ "884" "8107" "902" ]
    ++ lib.optionals (!stdenv.hostPlatform.isAarch64) [ "921" ]
, dynamic ? false
, haskellPackages
, haskell
}:
#
# The recommended way to override this package is
#
# pkgs.haskell-language-server.override { supportedGhcVersions = [ "901" ]; }
#
# for example. Read more about this in the haskell-language-server section of the nixpkgs manual.
#
let
  inherit (lib) concatStringsSep concatMapStringsSep take splitString pipe optionals;
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal enableCabalFlag disableCabalFlag;
  getPackages = version: haskell.packages."ghc${version}";
  tunedHls = hsPkgs:
    lib.pipe hsPkgs.haskell-language-server ([
      (haskell.lib.compose.overrideCabal (old: {
        enableSharedExecutables = dynamic;
        ${if !dynamic then "postInstall" else null} = ''
          ${old.postInstall or ""}

          remove-references-to -t ${hsPkgs.ghc} $out/bin/haskell-language-server
        '';
      }))
      ((if dynamic then enableCabalFlag else disableCabalFlag) "dynamic")
    ] ++ optionals (!dynamic) [
      justStaticExecutables
    ]);
  targets = version:
    let packages = getPackages version;
    in [
      "haskell-language-server-${packages.ghc.version}"
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
