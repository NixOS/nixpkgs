{
  lib,
  stdenv,
  haskellPackages,
  haskell,

  # Which GHC versions this hls can support.
  # These are looked up in nixpkgs as `pkgs.haskell.packages."ghc${version}`.
  # Run
  #  $ nix-instantiate --eval -E 'with import <nixpkgs> {}; builtins.attrNames pkgs.haskell.packages'
  # to list for your nixpkgs version.
  supportedGhcVersions ? [ "96" ],

  # Whether to build hls with the dynamic run-time system.
  # See https://haskell-language-server.readthedocs.io/en/latest/troubleshooting.html#static-binaries for more information.
  dynamic ? true,

  # Which formatters are supported. Pass `[]` to remove all formatters.
  #
  # Maintainers: if a new formatter is added, add it here and down in knownFormatters
  supportedFormatters ? [
    "ormolu"
    "fourmolu"
    "floskell"
    "stylish-haskell"
  ],
}:

# make sure the user only sets GHC versions that actually exist
assert supportedGhcVersions != [ ];
assert lib.asserts.assertEachOneOf "supportedGhcVersions" supportedGhcVersions (
  lib.pipe haskell.packages [
    lib.attrNames
    (lib.filter (lib.hasPrefix "ghc"))
    (map (lib.removePrefix "ghc"))
  ]
);

let
  # A mapping from formatter name to
  # - cabal flag to disable
  # - formatter-specific packages that can be stripped from the build of hls if it is disabled
  knownFormatters = {
    ormolu = {
      cabalFlag = "ormolu";
      packages = [
        "hls-ormolu-plugin"
      ];
    };
    fourmolu = {
      cabalFlag = "fourmolu";
      packages = [
        "hls-fourmolu-plugin"
      ];
    };
    floskell = {
      cabalFlag = "floskell";
      packages = [
        "hls-floskell-plugin"
      ];
    };
    stylish-haskell = {
      cabalFlag = "stylishhaskell";
      packages = [
        "hls-stylish-haskell-plugin"
      ];
    };
  };

in

# make sure any formatter that is set is actually supported by us
assert lib.asserts.assertEachOneOf "supportedFormatters" supportedFormatters (
  lib.attrNames knownFormatters
);

#
# The recommended way to override this package is
#
# pkgs.haskell-language-server.override { supportedGhcVersions = [ "90" "92"]; }
#
# for example. Read more about this in the haskell-language-server section of the nixpkgs manual.
#
let
  inherit (haskell.lib.compose)
    justStaticExecutables
    overrideCabal
    enableCabalFlag
    disableCabalFlag
    ;

  getPackages = version: haskell.packages."ghc${version}";

  # Given the list of `supportedFormatters`, remove every formatter that we know of (knownFormatters)
  # by disabling the cabal flag and also removing the formatter libraries.
  removeUnnecessaryFormatters =
    let
      # only formatters that were not requested
      unwanted = lib.pipe knownFormatters [
        (lib.filterAttrs (fmt: _: !(lib.elem fmt supportedFormatters)))
        lib.attrsToList
      ];
      # all flags to disable
      flags = map (fmt: fmt.value.cabalFlag) unwanted;
      # all dependencies to remove from hls
      deps = lib.concatMap (fmt: fmt.value.packages) unwanted;

      # remove nulls from a list
      stripNulls = lib.filter (x: x != null);

      # remove all unwanted dependencies of formatters we don’t want
      stripDeps = overrideCabal (drv: {
        libraryHaskellDepends = lib.pipe (drv.libraryHaskellDepends or [ ]) [
          # the existing list may contain nulls, so let’s strip them first
          stripNulls
          (lib.filter (dep: !(lib.elem dep.pname deps)))
        ];
      });

    in
    drv: lib.pipe drv ([ stripDeps ] ++ map disableCabalFlag flags);

  tunedHls =
    hsPkgs:
    lib.pipe hsPkgs.haskell-language-server (
      [
        (haskell.lib.compose.overrideCabal (old: {
          enableSharedExecutables = dynamic;
          ${if !dynamic then "postInstall" else null} = ''
            ${old.postInstall or ""}

            remove-references-to -t ${hsPkgs.ghc} $out/bin/haskell-language-server
          '';
        }))
        ((if dynamic then enableCabalFlag else disableCabalFlag) "dynamic")
        removeUnnecessaryFormatters
      ]
      ++ lib.optionals (!dynamic) [
        justStaticExecutables
      ]
    );

  targets =
    version:
    let
      packages = getPackages version;
    in
    [ "haskell-language-server-${packages.ghc.version}" ];

  makeSymlinks =
    version:
    lib.concatMapStringsSep "\n" (
      x: "ln -s ${tunedHls (getPackages version)}/bin/haskell-language-server $out/bin/${x}"
    ) (targets version);

in
stdenv.mkDerivation {
  pname = "haskell-language-server";
  version = haskellPackages.haskell-language-server.version;

  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${tunedHls (getPackages (builtins.head supportedGhcVersions))}/bin/haskell-language-server-wrapper $out/bin/haskell-language-server-wrapper
    ${lib.concatMapStringsSep "\n" makeSymlinks supportedGhcVersions}
  '';

  meta = haskellPackages.haskell-language-server.meta // {
    maintainers = [ lib.maintainers.maralorn ];
    longDescription = ''
      This package provides the executables ${
        lib.concatMapStringsSep ", " (x: lib.concatStringsSep ", " (targets x)) supportedGhcVersions
      } and haskell-language-server-wrapper.
      You can choose for which ghc versions to install hls with pkgs.haskell-language-server.override { supportedGhcVersions = [ "90" "92" ]; }.
    '';
  };
}
