{ lib, pkgs, makeWrapper, haskellPackages, haskell, pandoc, imagemagick, CoreServices }:

with lib;
with haskell.lib.compose;

let
  ldgallery-viewer = pkgs.callPackage ./viewer { inherit CoreServices; };
  inherit (haskellPackages) ldgallery-compiler;

in

# making sure that the versions of the compiler and viewer parts are in sync
assert ldgallery-compiler.version == versions.majorMinor ldgallery-viewer.version;

justStaticExecutables (overrideCabal (oldAttrs: {
  pname = "ldgallery"; # bundled viewer + compiler

  buildTools = (oldAttrs.buildTools or []) ++ [ makeWrapper pandoc ];

  prePatch = ''
    # add viewer dist to data
    ln -s "${ldgallery-viewer}/share/ldgallery/viewer" "data/"

    ${oldAttrs.prePatch or ""}
  '';

  postInstall = ''
    ${oldAttrs.postInstall or ""}

    # wrapper for runtime dependencies registration
    wrapProgram "$out/bin/ldgallery" \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ]}

    # bash completion
    mkdir -p "$out/share/bash-completion/completions"
    "$out/bin/ldgallery" \
      --help=bash \
      > "$out/share/bash-completion/completions/ldgallery"

    # man pages
    mkdir -p $out/share/man/man{1,7}
    ln -s ${ldgallery-viewer}/share/man/man7/* "$out/share/man/man7/"
    pandoc --standalone --to man \
      "../ldgallery-quickstart.7.md" \
      --output "$out/share/man/man7/ldgallery-quickstart.7"
    pandoc --standalone --to man \
      "ldgallery.1.md" \
      --output "$out/share/man/man1/ldgallery.1"
  '';

  # other package metadata (maintainer, description, license, ...)
  # are inherited from the compiler package
}) ldgallery-compiler)
