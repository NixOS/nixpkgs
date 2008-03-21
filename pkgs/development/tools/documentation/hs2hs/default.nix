#TODO write a function (abstraction)
args: with args;
args.stdenv.mkDerivation {
  name = "hsc2hs-darcs";

  src = bleedingEdgeRepos.sourceByName "hsc2hs";

  phases = "unpackPhase buildPhase";

  buildPhase  = ''
    ghc --make Setup.*hs -o setup
    ensureDir \out
     nix_ghc_pkg_tool join local-pkg-db
    ./setup configure --prefix=$out --package-db=local-pkg-db
    ./setup build
    ./setup install
  '';

  buildInputs = (with args; [ghc] ++ libs);

  meta = {
      description = "automate some parts of the process of writing Haskell bindings to C code";
      homepage = http://www.flapjax-lang.org/;
      license = "BSD3";
  };
}
