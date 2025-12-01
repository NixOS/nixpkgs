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

  exeWrapper =
    backend:
    let
      exe = "${diagrams-builder}/bin/diagrams-builder-${backend}";
    in
    ''
      test ! -x "${exe}" || \
      makeWrapper "${exe}" \
      "$out/bin/diagrams-builder-${backend}" \
        --set NIX_GHC ${ghc} \
        --set NIX_GHC_LIBDIR "$(${ghc} --print-libdir)"
    '';

  # Needs to match executable, suffix, not flag name
  allBackends = [
    "svg"
    "ps"
    "cairo"
    "rasterific"
    "pgf"
  ];

in

stdenv.mkDerivation {
  pname = "diagrams-builder";
  inherit (diagrams-builder) version;

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = lib.concatStringsSep "\n" (map exeWrapper allBackends);

  meta = diagrams-builder.meta;
}
