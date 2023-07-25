{ lib
, stdenv
, supportedGhcVersions ? [ "92" ]
, dynamic ? true
, haskellPackages
, haskell
}:
#
# The recommended way to override this package is
#
# pkgs.haskell-language-server.override { supportedGhcVersions = [ "90" "92"]; }
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
in assert supportedGhcVersions != []; stdenv.mkDerivation {
  pname = "haskell-language-server";
  version = haskellPackages.haskell-language-server.version;
  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${tunedHls (getPackages (builtins.head supportedGhcVersions))}/bin/haskell-language-server-wrapper $out/bin/haskell-language-server-wrapper
    ${concatMapStringsSep "\n" makeSymlinks supportedGhcVersions}
  '';
  meta = haskellPackages.haskell-language-server.meta // {
    maintainers = [ lib.maintainers.maralorn ];
    longDescription = ''
      This package provides the executables ${
        concatMapStringsSep ", " (x: concatStringsSep ", " (targets x))
        supportedGhcVersions
      } and haskell-language-server-wrapper.
      You can choose for which ghc versions to install hls with pkgs.haskell-language-server.override { supportedGhcVersions = [ "90" "92" ]; }.
    '';
  };
}
