{ haskell }:

with haskell.lib;

let
  # version in cabal file is invalid
  version = "1.2.1";

  pkgs = haskell.packages.ghc865.override {
    overrides = self: super: {
      # cabal2nix  --subpath server --maintainer offline --no-check --revision 1.2.1 https://github.com/hasura/graphql-engine.git
      hasura-graphql-engine = justStaticExecutables
        ((self.callPackage ./graphql-engine.nix { }).overrideDerivation (d: {
          name = "graphql-engine-${version}";

          inherit version;

          # hasura needs VERSION env exported during build
          preBuild = "export VERSION=${version}";
        }));

      hasura-cli = self.callPackage ./cli.nix {
        hasura-graphql-engine = self.hasura-graphql-engine // {
          inherit version;
        };
      };

      # internal dependencies, non published on hackage (find revisions in cabal.project file)
      # cabal2nix --revision <rev> https://github.com/hasura/ci-info-hs.git
      ci-info = self.callPackage ./ci-info.nix { };
      # cabal2nix --revision <rev> https://github.com/hasura/graphql-parser-hs.git
      graphql-parser = self.callPackage ./graphql-parser.nix { };
      # cabal2nix --revision <rev> https://github.com/hasura/pg-client-hs.git
      pg-client = self.callPackage ./pg-client.nix { };

      # version constrained dependencies, without these hasura will not build,
      # find versions in graphql-engine.cabal
      # cabal2nix cabal://dependent-map-0.2.4.0
      dependent-map = self.callPackage ./dependent-map.nix { };
      # cabal2nix cabal://dependent-sum-0.4
      dependent-sum = self.callPackage ./dependent-sum.nix { };
      # cabal2nix cabal://these-0.7.6
      these = doJailbreak (self.callPackage ./these.nix { });
      # cabal2nix cabal://immortal-0.2.2.1
      immortal = self.callPackage ./immortal.nix { };
      # cabal2nix cabal://network-uri-2.6.1.0
      network-uri = self.callPackage ./network-uri.nix { };
      # cabal2nix cabal://ghc-heap-view-0.6.0
      ghc-heap-view = disableLibraryProfiling (self.callPackage ./ghc-heap-view.nix { });

      # unmark broewn packages and do required modifications
      stm-hamt = doJailbreak (unmarkBroken super.stm-hamt);
      superbuffer = dontCheck (doJailbreak (unmarkBroken super.superbuffer));
      Spock-core = dontCheck (unmarkBroken super.Spock-core);
      stm-containers = dontCheck (unmarkBroken super.stm-containers);
      ekg-json = unmarkBroken super.ekg-json;
      list-t = dontCheck (unmarkBroken super.list-t);
      primitive-extras = unmarkBroken super.primitive-extras;
    };
  };
in {
  inherit (pkgs) hasura-graphql-engine hasura-cli;
}
