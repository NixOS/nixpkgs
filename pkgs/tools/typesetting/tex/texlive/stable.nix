{ callPackage, lib, fetchurl, useFixedHashes ? true, fetchpatch }:
let
  args = rec {
    version = {
      texliveYear = 2022;
      final = true;
    };

    mirrors = with version; [
      # tlnet-final snapshot; used when texlive.tlpdb is frozen
      # the TeX Live yearly freeze typically happens in mid-March
      "http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${toString texliveYear}/tlnet-final"
      "ftp://tug.org/texlive/historic/${toString texliveYear}/tlnet-final"
      # mostly just kept to prevent rebuilds :)
      "https://texlive.info/tlnet-archive/2023/03/19/tlnet"
    ];

    src = with version; fetchurl {
      urls = [
        "http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${toString texliveYear}/texlive-${toString texliveYear}0321-source.tar.xz"
        "ftp://tug.ctan.org/pub/tex/historic/systems/texlive/${toString texliveYear}/texlive-${toString texliveYear}0321-source.tar.xz"
      ];
      hash = "sha256-X/o0heUessRJBJZFD8abnXvXy55TNX2S20vNT9YXm1Y=";
    };

    tlpdb = import ./tlpdb.nix;
    tlpdbxzHash = "sha256-vm7DmkH/h183pN+qt1p1wZ6peT2TcMk/ae0nCXsCoMw=";

    fixedHashes = lib.optionalAttrs useFixedHashes (import ./fixed-hashes.nix);
    inherit useFixedHashes;
  };

  applyOverScope = f: scope: f (scope // {
      overrideScope = g: applyOverScope f (scope.overrideScope g);
  });

  # for backward compability
  compatFixups = scope:
    # TODO
    scope.pkgs // # remove this line to fix cross
    scope // {
      bin = scope.bin // {
        latexindent = lib.findFirst (p: p.tlType == "bin") scope.pkgs.latexindent.pkgs;
      };
    };

  f = x: applyOverScope compatFixups (callPackage ./. x);

# This construction ensures that the compat fixups are also applied when .override is used
in applyOverScope compatFixups (lib.makeOverridable f args)

# TODO: When using constructions like texlive.overrideScope ( ... ).override { ... },
# the overrideScope has no effect.
