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
  wrappedGhc = ghcWithPackages 
    (self: [ diagrams-builder ] ++ extraPackages self);
  ghcVersion = wrappedGhc.version;

  exeWrapper = backend : ''
    makeWrapper \
    "${diagrams-builder}/bin/diagrams-builder-${backend}" "$out/bin/diagrams-builder-${backend}" \
      --set NIX_GHC ${wrappedGhc}/bin/ghc \
      --set NIX_GHC_LIBDIR ${wrappedGhc}/lib/ghc-${ghcVersion}
  '';
  
  backends = ["svg" "cairo" "ps"];

in

stdenv.mkDerivation {
  name = "diagrams-builder";

  buildInputs = [ makeWrapper ];

  buildCommand = with stdenv.lib; 
    concatStrings (intersperse "\n" (map exeWrapper backends));

  # Will be faster to build the wrapper locally then to fetch it from a binary cache.
  preferLocalBuild = true;
  meta = diagrams-builder.meta;
}