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

  f = x: applyOverScope compatFixups ((callPackage ./. x).overrideScope (self: super: {
    bin = super.bin // {
      core = super.bin.core.overrideAttrs (olds: {
        patches = (olds.patches or []) ++ [
          # Fix implicit `int` on `main`, which results in an error when building with clang 16.
          # This is fixed upstream and can be dropped with the 2023 release.
          ./fix-implicit-int.patch
        ];
      });

      core-big = super.bin.core-big.overrideAttrs (olds: {
        patches = (olds.patches or []) ++ [
          # fixes a security-issue in luatex that allows arbitrary code execution even with shell-escape disabled, see https://tug.org/~mseven/luatex.html
          (fetchpatch {
            name = "CVE-2023-32700.patch";
            url = "https://tug.org/~mseven/luatex-files/2022/patch";
            hash = "sha256-o9ENLc1ZIIOMX6MdwpBIgrR/Jdw6tYLmAyzW8i/FUbY=";
            excludes = [  "build.sh" ];
            stripLen = 1;
          })
          # Fix implicit `int` on `main`, which results in an error when building with clang 16.
          # This is fixed upstream and can be dropped with the 2023 release.
          ./fix-implicit-int.patch
        ];
      });
    };

    pkgs = super.pkgs.override (old: lib.recursiveUpdate old {
      # tlpdb lists license as "unknown", but the README says lppl13: http://mirrors.ctan.org/language/arabic/arabi-add/README
      arabi-add.license = [  "lppl13c" ];
      # tlpdb lists license as "noinfo", but it's gpl3: https://github.com/luigiScarso/context-npp
      npp-for-context.license = [  "gpl3Only" ];
    });
  }));


# This construction ensures that the compat fixups are also applied when .override is used
in applyOverScope compatFixups (lib.makeOverridable f args)

# TODO: When using constructions like texlive.overrideScope ( ... ).override { ... },
# the overrideScope has no effect.
