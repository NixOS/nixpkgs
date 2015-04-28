/*
  If user need access to more haskell package for building his
  diagrams, he simply has to pass these package through the
  extra packages function as follow in `config.nix`:
  
  ~~~
  diagrams-builder.override {
    extraPackages = self : [myHaskellPackage];
  }
  ­~~~
*/

{ stdenv, ghcWithPackages, makeWrapper, diagrams-builder, extraPackages ? (self: []) }:
let
  # Used same technique as for the yiCustom package.
  w = ghcWithPackages 
    (self: [ diagrams-builder ] ++ extraPackages self);
  wrappedGhc = w.override { ignoreCollisions = true; };
  ghcVersion = w.version;
in
stdenv.mkDerivation {
  name = "diagrams-builder";
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper \
    "${diagrams-builder}/bin/diagrams-builder-svg" "$out/bin/diagrams-builder-svg" \
      --set NIX_GHC ${wrappedGhc}/bin/ghc \
      --set NIX_GHC_LIBDIR ${wrappedGhc}/lib/ghc-${ghcVersion}

    makeWrapper \
    "${diagrams-builder}/bin/diagrams-builder-cairo" "$out/bin/diagrams-builder-cairo" \
      --set NIX_GHC ${wrappedGhc}/bin/ghc \
      --set NIX_GHC_LIBDIR ${wrappedGhc}/lib/ghc-${ghcVersion}

    makeWrapper \
    "${diagrams-builder}/bin/diagrams-builder-ps" "$out/bin/diagrams-builder-ps" \
    --set NIX_GHC ${wrappedGhc}/bin/ghc \
    --set NIX_GHC_LIBDIR ${wrappedGhc}/lib/ghc-${ghcVersion}
  '';
  # Will be faster to build the wrapper locally then to fetch it from a binary cache.
  preferLocalBuild = true;
  meta = diagrams-builder.meta;
}