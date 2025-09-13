/*
  If a user needs access to more haskell packages for building their
  diagrams, they simply have to pass these packages through the
  extraPackages function, as follows:

  ~~~
  diagrams-builder.override {
    extraPackages = self: [ self.myHaskellPackage ];
  }
  ­~~~
*/

{
  lib,
  stdenv,
  ghcWithPackages,
  makeWrapper,
  diagrams-builder,
  extraPackages ? (self: [ ]),
}:

let

  # Used same technique as for the yiCustom package.
  wrappedGhc = ghcWithPackages (self: [ diagrams-builder ] ++ extraPackages self);
  ghc = lib.getExe' wrappedGhc "ghc";

  exeWrapper = backend: ''
    makeWrapper \
    "${diagrams-builder}/bin/diagrams-builder-${backend}" "$out/bin/diagrams-builder-${backend}" \
      --set NIX_GHC ${ghc} \
      --set NIX_GHC_LIBDIR "$(${ghc} --print-libdir)"
  '';

  backends = [
    "svg"
    "cairo"
    "ps"
  ];

in

stdenv.mkDerivation {
  name = "diagrams-builder";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = lib.concatStringsSep "\n" (map exeWrapper backends);

  # Will be faster to build the wrapper locally then to fetch it from a binary cache.
  preferLocalBuild = true;
  meta = diagrams-builder.meta;
}
