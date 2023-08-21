{ callPackage, lib, fetchurl, useFixedHashes ? true, fetchpatch }:
lib.makeOverridable callPackage ./. rec {
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
}
